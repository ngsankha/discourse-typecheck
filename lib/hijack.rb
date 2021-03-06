# frozen_string_literal: true

require_dependency 'method_profiler'

# This module allows us to hijack a request and send it to the client in the deferred job queue
# For cases where we are making remote calls like onebox or proxying files and so on this helps
# free up a unicorn worker while the remote IO is happening
module Hijack

  def hijack(&blk)
    controller_class = self.class

    if hijack = request.env['rack.hijack']

      request.env['discourse.request_tracker.skip'] = true
      request_tracker = request.env['discourse.request_tracker']

      # in the past unicorn would recycle env, this is not longer the case
      env = request.env
      request_copy = ActionDispatch::Request.new(env)

      transfer_timings = MethodProfiler.transfer

      io = hijack.call

      original_headers = response.headers

      Scheduler::Defer.later("hijack #{params["controller"]} #{params["action"]}") do

        MethodProfiler.start(transfer_timings)
        begin
          Thread.current[Logster::Logger::LOGSTER_ENV] = env
          # do this first to confirm we have a working connection
          # before doing any work
          io.write "HTTP/1.1 "

          # this trick avoids double render, also avoids any litter that the controller hooks
          # place on the response
          instance = controller_class.new
          response = ActionDispatch::Response.new
          instance.response = response

          instance.request = request_copy
          original_headers&.each do |k, v|
            # hash special handling so skip
            if k != "Cache-Control"
              instance.response.headers[k] = v
            end
          end

          begin
            instance.instance_eval(&blk)
          rescue => e
            # TODO we need to reuse our exception handling in ApplicationController
            Discourse.warn_exception(e, message: "Failed to process hijacked response correctly", env: env)
          end

          unless instance.response_body || response.committed?
            instance.status = 500
          end

          response.commit!

          body = response.body

          headers = response.headers
          # add cors if needed
          if cors_origins = env[Discourse::Cors::ORIGINS_ENV]
            Discourse::Cors.apply_headers(cors_origins, env, headers)
          end

          headers['Content-Length'] = body.bytesize
          headers['Content-Type'] = response.content_type || "text/plain"
          headers['Connection'] = "close"

          status_string = Rack::Utils::HTTP_STATUS_CODES[response.status.to_i] || "Unknown"
          io.write "#{response.status} #{status_string}\r\n"

          timings = MethodProfiler.stop
          if timings && duration = timings[:total_duration]
            headers["X-Runtime"] = "#{"%0.6f" % duration}"
          end

          headers.each do |name, val|
            io.write "#{name}: #{val}\r\n"
          end

          io.write "\r\n"
          io.write body
        rescue Errno::EPIPE, IOError
          # happens if client terminated before we responded, ignore
          io = nil
        ensure
          MethodProfiler.clear
          Thread.current[Logster::Logger::LOGSTER_ENV] = nil

          io.close if io rescue nil

          if request_tracker
            status = response.status rescue 500
            request_tracker.log_request_info(env, [status, headers || {}, []], timings)
          end
        end
      end
      # not leaked out, we use 418 ... I am a teapot to denote that we are hijacked
      render plain: "", status: 418
    else
      blk.call
    end
  end
end
