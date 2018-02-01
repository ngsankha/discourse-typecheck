require './db_types.rb'
puts '--------------------------------------------------------'

module RDL::Globals
  # Map from table names (symbols) to their schema types, which should be a Table type
  @db_schema = {}
end

class << RDL::Globals
  attr_accessor :db_schema
end



puts "\n\n\n\n\n\n\n\n\n\n\n\n\n\n Made it here.\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"

def add_assoc(hash, aname, aklass)
  kl_type = RDL::Type::SingletonType.new(aklass)
  if hash[aname]
    hash[aname] = RDL::Type::UnionType.new(hash[aname], kl_type)
  else
    hash[aname] = kl_type unless hash[aname]
  end
  hash
end

Rails.application.eager_load!
MODELS = ActiveRecord::Base.descendants.each { |m|
  begin
    m.send(:load_schema) unless m.abstract_class?
  rescue
    puts "#{m} didn't work"
  end }

MODELS.each { |model|
  next if model.to_s == "ApplicationRecord"
  next if model.to_s == "GroupManager"
  RDL.nowrap model
  s1 = {}
  model.columns_hash.each { |k, v| t_name = v.type.to_s.camelize
    if t_name == "Boolean"
      t_name = "%bool"
      s1[k] = RDL::Globals.types[:bool]
    else
      s1[k] = RDL::Type::NominalType.new(t_name)
    end
    RDL.type model, (k+"=").to_sym, "(#{t_name}) -> #{t_name}", wrap: false ## create method type for column setter
    RDL.type model, (k).to_sym, "() -> #{t_name}", wrap: false ## create method type for column getter
  }
  #s1 = model.columns_hash.transform_values { |v| t_name = v.type.to_s.camelize; RDL.type ""; RDL::Type::NominalType.new(t_name) }
  s2 = s1.transform_keys { |k| k.to_sym }
  assoc = {}
  model.reflect_on_all_associations.each { |a|
    add_assoc(assoc, a.macro, a.name)
    RDL.type model, a.name, "() -> ActiveRecord_Relation<#{a.name.to_s.camelize.singularize}>", wrap: false ## TODO: This actually returns an Associations CollectionProxy, which is a descendant of ActiveRecord_Relation (see below actual type). Not yet sure if this makes a difference in practice.
    #ActiveRecord_Associations_CollectionProxy<#{a.name.to_s.camelize.singularize}>'
  }
  s2[:__associations] = RDL::Type::FiniteHashType.new(assoc, nil)
  base_name = model.to_s
  base_type = RDL::Type::NominalType.new(model.to_s)
  hash_type = RDL::Type::FiniteHashType.new(s2, nil)
  schema = RDL::Type::GenericType.new(base_type, hash_type)
  RDL::Globals.db_schema[base_name.to_sym] = schema
}

## uncomment the below to print out schema
=begin
RDL::Globals.db_schema.each { |k, v|
  puts "#{k} has the following schema:"
  v.params[0].elts.each { |k1, v1|
    puts "     #{k1} => #{v1}"
  }
}
=end

## below is super hacky way around "class_name" issue for now
class GrantedBy
  RDL::Globals.db_schema[:GrantedBy] = RDL::Globals.parser.scan_str "#T GrantedBy<{dummy: Integer}>"
end

## currently unchecked types
RDL.type Badge, 'self.trust_level_badge_ids', '() -> [1,2,3,4]', wrap: false
RDL.type User, :email, '() -> String', wrap: false
RDL.type User, :email=, '(String) -> String', wrap: false
RDL.type User, :password=, '(String) -> String', wrap: false
RDL.type EmailToken, 'self.valid_after', '() -> Hash', wrap: false
RDL.type EmailToken, 'self.confirm', '(String) -> %bool', wrap: false
RDL.type ActiveRecord::Base, 'self.with_deleted', '() -> ``RDL::Type::GenericType.new(RDL::Type::NominalType.new(ActiveRecord_Relation), DBType.rec_to_nominal(trec))``', wrap: false
RDL.type PostActionType, 'self.notify_flag_type_ids', '() -> Array<Integer>', wrap: false
RDL.type PostActionType, 'self.flag_types_without_custom', '() -> Array<Integer>', wrap: false
RDL.var_type User, :@raw_password, "String"
RDL.var_type User, :@password_required, "%bool"

## rails library method types
RDL.type ActiveRecord::AttributeMethods::ClassMethods, 'attribute_names', '() -> Array<String>', wrap: :false
RDL.type ActiveRecord_Relation, :attribute_names, '() -> Array<String>', wrap: false
RDL.type ActiveRecord_Relation, :active, '() -> self', wrap: false


## checked types
RDL.type User, 'self.new_from_params', '({ name: String, email: String, password: String, username: String }) -> User', typecheck: :later, wrap: false
RDL.type User, 'self.find_by_username', '(String) -> User', typecheck: :later, wrap: false
RDL.type User, :featured_user_badges, '(?Integer) -> %any', typecheck: :later, wrap: false
RDL.type User, :email_confirmed?, '() -> %bool', typecheck: :later, wrap: false
RDL.type EmailToken, :active, '() -> ActiveRecord_Relation<EmailToken>', wrap: false, typecheck: :later
RDL.type User, :activate, '() -> %bool', typecheck: :later, wrap: false
RDL.type User, :number_of_deleted_posts, '() -> Integer', typecheck: :later, wrap: false
# Below needs where with ActiveRecord_Relation inputs allowed
#RDL.type User, :number_of_flagged_posts, '() -> Integer', typecheck: :later, wrap: false 
RDL.type User, :number_of_flags_given, '() -> Integer', typecheck: :later, wrap: false
RDL.type User, :create_user_profile, '() -> UserProfile', typecheck: :later, wrap: false
# Below needs scope
#RDL.type User, :is_singular_admin?, '() -> %bool', typecheck: :later, wrap: false 
RDL.type User, :create_user_option, '() -> UserOption', typecheck: :later, wrap: false
RDL.type User, :create_email_token, '() -> EmailToken', typecheck: :later, wrap: false
RDL.type User, :update_username_lower, '() -> String', typecheck: :later, wrap: false
# Need to resolve the nil < bool issue below before proceeding.
#RDL.type User, :expire_tokens_if_password_changed, '() -> %bool', typecheck: :later, wrap: false 
RDL.type Post, :seen?, '(User) -> %bool', typecheck: :later, wrap: false
RDL.type Post, 'self.find_by_detail', '(String, String) -> Post', typecheck: :later, wrap: false


## typecheck
RDL.do_typecheck :later
