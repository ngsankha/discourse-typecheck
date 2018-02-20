#### get rid of static errors

class ActiveRecord::Base
  extend RDL::Annotate

  type :initialize, '(``DBType.rec_to_schema_type(trec, true)``) -> self', wrap: false
  type 'self.create', '(``DBType.rec_to_schema_type(trec, true)``) -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :initialize, '() -> self', wrap: false
  type 'self.create', '() -> ``DBType.rec_to_nominal(trec)``', wrap: false

end
module ActiveRecord::Core::ClassMethods
  extend RDL::Annotate
  ## Types from this module are used when receiver is ActiveRecord::Base

  type :find, '(Integer) -> ``DBType.find_output_type(trec, targs)``', wrap: false
  type :find, '(Array<Integer>) -> ``DBType.find_output_type(trec, targs)``', wrap: false
  type :find, '(Integer, Integer, *Integer) -> ``DBType.find_output_type(trec, targs)``', wrap: false
  type :find_by, '(``DBType.rec_to_schema_type(trec, true)``) -> ``DBType.rec_to_nominal(trec)``', wrap: false
  ## TODO: find_by's with conditions given as string

end

module ActiveRecord::FinderMethods
  extend RDL::Annotate
  ## Types from this module are used when receiver is ActiveRecord_Relation

  type :find, '(Integer) -> ``DBType.find_output_type(trec, targs)``', wrap: false
  type :find, '(Array<Integer>) -> ``DBType.find_output_type(trec, targs)``', wrap: false
  type :find, '(Integer, Integer, *Integer) -> ``DBType.find_output_type(trec, targs)``', wrap: false
  type :find_by, '(``DBType.rec_to_schema_type(trec, true)``) -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :first, '() -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :first!, '() -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :first, '(Integer) -> ``DBType.rec_to_array(trec)``', wrap: false
  type :last, '() -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :last!, '() -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :last, '(Integer) -> ``DBType.rec_to_array(trec)``', wrap: false
  type :take, '() -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :take!, '() -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :take, '(Integer) -> ``DBType.rec_to_array(trec)``', wrap: false
  type :exists?, '() -> %bool', wrap: false
  type :exists?, '(Integer or String) -> %bool', wrap: false
  type :exists?, '(``DBType.exists_input_type(trec, targs)``) -> %bool', wrap: false


  ## TODO: find_by's with conditions given as string

end

module ActiveRecord::Querying
  extend RDL::Annotate
  ## Types from this module are used when receiver is ActiveRecord::Base


  type :first, '() -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :first!, '() -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :first, '(Integer) -> ``DBType.rec_to_array(trec)``', wrap: false
  type :last, '() -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :last!, '() -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :last, '(Integer) -> ``DBType.rec_to_array(trec)``', wrap: false
  type :take, '() -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :take!, '() -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :take, '(Integer) -> ``DBType.rec_to_array(trec)``', wrap: false
  type :exists?, '() -> %bool', wrap: false
  type :exists?, '(Integer or String) -> %bool', wrap: false
  type :exists?, '(``DBType.exists_input_type(trec, targs)``) -> %bool', wrap: false

  type :where, '(``DBType.where_input_type(trec, targs)``) -> ``DBType.where_output_type(trec, targs)``', wrap: false
  # TODO: AST needs to be semantically correct in the strings case
  type :where, '(String, Hash) -> ``DBType.where_output_type(trec, targs)``', wrap: false
  type :where, '(String, *String) -> ``DBType.where_output_type(trec, targs)``', wrap: false
  type :where, '() -> ``DBType.where_output_type(trec, targs)``', wrap: false

  type :joins, '(``DBType.joins_one_input_type(trec, targs)``) -> ``DBType.joins_output(trec, targs)``', wrap: false
  type :joins, '(``DBType.joins_multi_input_type(trec, targs)``, Symbol or Hash, *Symbol or Hash) -> ``DBType.joins_output(trec, targs)``', wrap: false

  type :group, '(Symbol) -> ``DBType.group_output_type(trec, targs)``', wrap: false
  type :group, '(Symbol, *Symbol) -> ``DBType.group_output_type(trec, targs)``', wrap: false
  type :select, '(Symbol or String or Array<String>, *Symbol or String or Array<String>) -> ``DBType.select_output_type(trec, targs)``', wrap: false
  type :order, '(String) -> ``DBType.order_output_type(trec, targs)``', wrap: false
  type :includes, '(``DBType.joins_one_input_type(trec, targs)``) -> ``DBType.joins_output(trec, targs)``', wrap: false
  type :includes, '(``DBType.joins_multi_input_type(trec, targs)``, Symbol or Hash, *Symbol or Hash) -> ``DBType.joins_output(trec, targs)``', wrap: false
  type :limit, '(Integer) -> ``DBType.limit_output_type(trec, targs)``', wrap: false
  type :count, '() -> Integer', wrap: false
  type :count, '(``DBType.count_input(trec, targs)``) -> Integer', wrap: false
  type :destroy_all, '() -> ``DBType.rec_to_array(trec)``', wrap: false

  type :+, '(%any) -> ``DBType.plus_output_type(trec, targs)``', wrap: false

  type :not, '(``DBType.not_input_type(trec, targs)``) -> ``DBType.not_output_type(trec, targs)``', wrap: false

end

module ActiveRecord::QueryMethods
  extend RDL::Annotate
  ## Types from this module are used when receiver is ActiveRecord_relation

  type :where, '(``DBType.where_input_type(trec, targs)``) -> ``DBType.where_output_type(trec, targs)``', wrap: false
  type :where, '() -> ``DBType.where_output_type(trec, targs)``', wrap: false

  type :joins, '(``DBType.joins_one_input_type(trec, targs)``) -> ``DBType.joins_output(trec, targs)``', wrap: false
  type :joins, '(``DBType.joins_multi_input_type(trec, targs)``, Symbol or Hash, *Symbol or Hash) -> ``DBType.joins_output(trec, targs)``', wrap: false

  type :group, '(Symbol) -> ``DBType.group_output_type(trec, targs)``', wrap: false
  type :group, '(Symbol, *Symbol) -> ``DBType.group_output_type(trec, targs)``', wrap: false
  # type :select, '(Symbol or String or Array<String>, *Symbol or String or Array<String>) -> ``RDL::Type::GenericType.new(RDL::Type::NominalType.new(ActiveRecord_Relation), trec.params[0])``', wrap: false
  # type :order, '(String) -> ``RDL::Type::GenericType.new(RDL::Type::NominalType.new(ActiveRecord_Relation), trec.params[0])``', wrap: false
  # type :includes, '(``DBType.joins_one_input_type(trec, targs)``) -> ``DBType.joins_output(trec, targs)``', wrap: false
  # type :includes, '(``DBType.joins_multi_input_type(trec, targs)``, Symbol or Hash, *Symbol or Hash) -> ``DBType.joins_output(trec, targs)``', wrap: false
  # #type :includes, '(*Symbol or Hash) -> %any', wrap: false
  # type :limit, '(Integer) -> ``trec``', wrap: false

end


# class ActiveRecord::QueryMethods::WhereChain
#   extend RDL::Annotate
#   type_params [:t], :dummy

#   type :not, '(``DBType.not_input_type(trec, targs)``) -> ``RDL::Type::GenericType.new(RDL::Type::NominalType.new(ActiveRecord_Relation), trec.params[0])``', wrap: false

# end

# module ActiveRecord::Delegation
#   extend RDL::Annotate

#   type :+, '(%any) -> ``DBType.plus_output_type(trec, targs)``', wrap: false

# end

# class JoinTable
#   extend RDL::Annotate
#   type_params [:orig, :joined], :dummy
#   ## type param :orig will be nominal type of base table in join
#   ## type param :joined will be a union type of all joined tables, or just a nominal type if there's only one

#   ## this class is meant to only be the type parameter of ActiveRecord_Relation or WhereChain, expressing multiple joined tables instead of just a single table
# end



# module ActiveRecord::Scoping::Named::ClassMethods
#   extend RDL::Annotate
#   type :all, '() -> ``RDL::Type::GenericType.new(RDL::Type::NominalType.new(ActiveRecord_Relation), DBType.rec_to_nominal(trec))``', wrap: false

# end

module ActiveRecord::Persistence
  extend RDL::Annotate
  type :update!, '(``DBType.rec_to_schema_type(trec, true)``) -> %bool', wrap: false
end

module ActiveRecord::Calculations
  extend RDL::Annotate
  type :count, '() -> Integer', wrap: false
  type :count, '(``DBType.count_input(trec, targs)``) -> Integer', wrap: false
end

class ActiveRecord_Relation
  ## In practice, this is actually a private class nested within
  ## each ActiveRecord::Base, e.g. Person::ActiveRecord_Relation.
  ## Using this class just for type checking.
  extend RDL::Annotate
  include ActiveRecord::QueryMethods
  include ActiveRecord::FinderMethods
  include ActiveRecord::Calculations
  include ActiveRecord::Delegation

  type_params [:t], :dummy

  type :each, '() -> Enumerator<t>', wrap: false
  type :each, '() { (t) -> %any } -> Array<t>', wrap: false
  type :empty?, '() -> %bool', wrap: false
  type :present?, '() -> %bool', wrap: false
  type :create, '(``DBType.rec_to_schema_type(trec, true)``) -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :create, '() -> ``DBType.rec_to_nominal(trec)``', wrap: false
  type :destroy_all, '() -> ``DBType.rec_to_array(trec)``', wrap: false
end


class DBType

  ## given a receiver type in various kinds of query calls, returns the accepted finite hash type input,
  ## or a union of types if the receiver represents joined tables.
  ## [+ trec +] is the type of the receiver in the method call.
  ## [+ check_col +] is a boolean indicating whether or not the column types (i.e., values in the finite hash type) will be checked.
  def self.rec_to_schema_type(trec, check_col, takes_array=false)
    case trec
    when RDL::Type::GenericType
      # TODO: fix this, see `model.reflect_on_all_associations` in typecheck.rb
      # raise "Shouldn't get GenericType"
      raise "Unexpected type #{trec}." unless (trec.base.klass == ActiveRecord_Relation) || (trec.base.klass == ActiveRecord::QueryMethods::WhereChain)
      param = trec.params[0]
      case param
      when RDL::Type::NominalType
        tname = param.klass.to_s.to_sym
        return table_name_to_schema_type(tname, check_col, takes_array)
      else
        raise RDL::Typecheck::StaticTypeError, "Unexpected type parameter in  #{trec}."
      end
    when RDL::Type::SingletonType
      raise RDL::Typecheck::StaticTypeError, "Unexpected receiver type #{trec}." unless trec.val.is_a?(Class)
      tname = trec.val.to_s.to_sym
      return table_name_to_schema_type(tname, check_col, takes_array)
    when RDL::Type::NominalType
      tname = trec.name.to_sym
      return table_name_to_schema_type(tname, check_col, takes_array)
    when RDL::Type::AstNode
      raise RDL::Typecheck::StaticTypeError, "Unexpected receiver type #{trec}." unless trec.op == :SELECT
      tname = trec.val.to_sym
      return table_name_to_schema_type(tname, check_col, takes_array)
    else
      raise RDL::Typecheck::StaticTypeError, "Unexpected receiver type #{trec}."
    end
  end

  ## turns a given table name into the appropriate finite hash type based on table schema, with optional or top-type values
  ## [+ tname +] is the table name as a symbol
  ## [+ check_col +] is a boolean indicating whether or not column types will eventually be checked
  def self.table_name_to_schema_type(tname, check_col, takes_array=false)
    h = {}
    ttype = RDL::Globals.db_schema[tname]
    raise RDL::Typecheck::StaticTypeError, "No table type for #{tname} found." unless ttype
    tschema = ttype.params[0].elts.except(:__associations)
    tschema.each { |k, v|
      if check_col
        v = RDL::Type::UnionType.new(v, RDL::Type::GenericType.new(RDL::Globals.types[:array], v)) if takes_array
        h[k] = RDL::Type::OptionalType.new(v)
      else
        h[k] = RDL::Type::OptionalType.new(RDL::Globals.types[:top])
      end
    }
    RDL::Type::FiniteHashType.new(h, nil)
  end

  def self.where_input_type(trec, targs)
    case trec
    when RDL::Type::AstNode
      RDL::Globals.types[:top] # TODO: add a better condition
    else
      tschema = rec_to_schema_type(trec, true)
      return RDL::Type::UnionType.new(tschema, RDL::Globals.types[:string], RDL::Globals.types[:array]) ## no indepth checking for string or array cases
    end
  end

  def self.where_output_type(trec, targs)
    puts trec, targs
    case trec
    when RDL::Type::GenericType
      # TODO: remove this; shouldn't be there after model.reflect_on_all_associations in typecheck.rb
      raise "Unexpected type #{trec}." unless trec.base.klass == ActiveRecord_Relation
      select_node = RDL::Type::AstNode.new(:SELECT, trec.params[0])
      unless targs.size == 0
        cond_node = RDL::Type::AstNode.new(:COND, targs)
        and_node = RDL::Type::AstNode.new(:AND, nil)
        where_node = RDL::Type::AstNode.new(:WHERE, nil)
        and_node.insert cond_node
        where_node.insert and_node
        select_node.insert where_node
      end
      return select_node
    when RDL::Type::SingletonType
      select_node = RDL::Type::AstNode.new(:SELECT, trec)
      unless targs.size == 0
        cond_node = RDL::Type::AstNode.new(:COND, targs)
        and_node = RDL::Type::AstNode.new(:AND, nil)
        where_node = RDL::Type::AstNode.new(:WHERE, nil)
        and_node.insert cond_node
        where_node.insert and_node
        select_node.insert where_node
      end
      return select_node
    when RDL::Type::AstNode
      raise RDL::Typecheck::StaticTypeError, "Expected a SELECT node" unless trec.op == :SELECT
      cond_node = RDL::Type::AstNode.new(:COND, targs)
      where_node = trec.find_one :WHERE
      unless where_node
        where_node = RDL::Type::AstNode.new(:WHERE, nil)
        trec.insert where_node
      end
      and_node = where_node.find_one :AND
      unless and_node
        and_node = RDL::Type::AstNode.new(:AND, nil)
        where_node.insert and_node
      end
      and_node.insert cond_node
      return trec
    else
      raise RDL::Typecheck::StaticTypeError, "Unexpected receiver type #{trec}."
    end
  end

  ## given a type (usually representing a receiver type in a method call), this method returns the nominal type version of that type.
  ## if the given type represents a joined table, then we return the nominal type version of the *base* of the joined table.
  ## [+ t +] is the type for which we want the nominal type.
  def self.rec_to_nominal(t)
    case t
    when RDL::Type::SingletonType
      val = t.val
      raise RDL::Typecheck::StaticTypeError, "Expected class singleton type, got #{val} instead." unless val.is_a?(Class)
      return RDL::Type::NominalType.new(val)
    when RDL::Type::AstNode
      raise RDL::Typecheck::StaticTypeError, "got unexpected query #{t.op}" unless t.op == :SELECT
      return RDL::Type::NominalType.new(t.val)
    when RDL::Type::GenericType
      raise "Shouldn't get GenericType"
    end
  end

  def self.rec_to_array(trec)
    RDL::Type::GenericType.new(RDL::Globals.types[:array], rec_to_nominal(trec))
  end

  def self.not_input_type(trec, targs)
    case trec
    when RDL::Type::AstNode
      raise RDL::Typecheck::StaticTypeError, "Expected only one hash to .not" unless targs.length == 1
      return rec_to_schema_type(trec.val, true) if trec.op == :SELECT
      raise RDL::Typecheck::StaticTypeError, "Unsupported not operation"
    else
      tschema = rec_to_schema_type(trec, true)
      return RDL::Type::UnionType.new(tschema, RDL::Globals.types[:string], RDL::Globals.types[:array]) ## no indepth checking for string or array cases
    end
  end

  def self.not_output_type(trec, targs)
    case trec
    when RDL::Type::AstNode
      raise RDL::Typecheck::StaticTypeError, "Expected a SELECT node" unless trec.op == :SELECT
      not_node = RDL::Type::AstNode.new(:NOT, nil)
      cond_node = RDL::Type::AstNode.new(:COND, targs)
      where_node = trec.find_one :WHERE
      unless where_node
        where_node = RDL::Type::AstNode.new(:WHERE, nil)
        trec.insert where_node
      end
      not_node.insert cond_node
      where_node.insert not_node
      return trec
    else
      raise RDL::Typecheck::StaticTypeError, "Unexpected receiver type #{trec}."
    end
  end

  def self.joins_one_input_type(trec, targs)
    return RDL::Globals.types[:top] unless targs.size == 1 ## trivial case, won't be matched
    case trec
    when RDL::Type::SingletonType
      base_klass = trec.val
    when RDL::Type::AstNode
      raise "Unexpected type #{trec}" unless trec.op == :SELECT
      base_klass = trec.val.klass
    else
      raise "unexpected receiver type #{trec}"
    end
    case targs[0]
    when RDL::Type::SingletonType
      sym = targs[0].val
      raise RDL::Typecheck::StaticTypeError, "Unexpected arg type #{trec} in call to joins." unless sym.is_a?(Symbol)
      raise RDL::Typecheck::StaticTypeError, "#{trec} has no association to #{targs[0]}, cannot perform joins." unless associated_with?(base_klass, sym)
      return targs[0]
    when RDL::Type::FiniteHashType
      targs[0].elts.each { |key, val|
        raise RDL::Typecheck::StaticTypeError, "Unexpected hash arg type #{targs[0]} in call to joins." unless key.is_a?(Symbol) && val.is_a?(RDL::Type::SingletonType) && val.val.is_a?(Symbol)
        val_sym = val.val
        raise RDL::Typecheck::StaticTypeError, "#{trec} has no association to #{key}, cannot perform joins." unless associated_with?(base_klass, key)
        key_klass = key.to_s.singularize.camelize
        raise RDL::Typecheck::StaticTypeError, "#{key} has no association to #{val_sym}, cannot perform joins." unless associated_with?(key_klass, val_sym)
      }
      return targs[0]
    else
      raise RDL::Typecheck::StaticTypeError, "Unexpected arg type #{targs[0]} in call to joins."
    end
  end

  def self.associated_with?(rec, sym)
    tschema = RDL::Globals.db_schema[rec.to_s.to_sym]
    raise RDL::Typecheck::StaticTypeError, "No table type for #{rec} found." unless tschema
    schema = tschema.params[0].elts
    assoc = schema[:__associations]
    raise RDL::Typecheck::StaticTypeError, "Table #{rec} has no associations, cannot perform joins." unless assoc
    assoc.elts.each { |key, value|
      case value
      when RDL::Type::SingletonType
        return true if value.val == sym ## no need to change any plurality here
      when RDL::Type::UnionType
        ## for when rec has multiple of the same kind of association
        value.types.each { |t|
          raise "Unexpected type #{t}." unless t.is_a?(RDL::Type::SingletonType) && (t.val.class == Symbol)
          return true if t.val == sym
        }
      else
        raise RDL::Typecheck::StaticTypeError, "Unexpected association type #{value}"
      end
    }
    return false
  end

  def self.joins_multi_input_type(trec, targs)
    return RDL::Globals.types[:top] unless targs.size > 1 ## trivial case, won't be matched
    targs.each { |arg|
      joins_one_input_type(trec, [arg])
    }
    return targs[0] ## since this method is called as first argument in type
  end

  def self.get_joined_args(targs)
    arg_types = []
    targs.each { |arg|
    case arg
    when RDL::Type::SingletonType
      raise RDL::Typecheck::StaticTypeError, "Unexpected joins arg type #{arg}" unless (arg.val.class == Symbol)
      arg_types << RDL::Type::NominalType.new(arg.val.to_s.singularize.camelize)
    when RDL::Type::FiniteHashType
      hsh = arg.elts
      raise 'not supported' unless hsh.size == 1
      key, val = hsh.first
      val = val.val
      arg_types << RDL::Type::UnionType.new(RDL::Type::NominalType.new(key.to_s.singularize.camelize), RDL::Type::NominalType.new(val.to_s.singularize.camelize))
    else
      raise "Unexpected arg type #{arg} to joins."
    end
    }
    if arg_types.size > 1
      return RDL::Type::UnionType.new(*arg_types)
    elsif arg_types.size == 1
      return arg_types[0]
    else
      raise "oops, didn't expect to get here."
    end
  end

  def self.joins_output(trec, targs)
    arg_type = get_joined_args(targs)
    case trec
    when RDL::Type::SingletonType
      select_node = RDL::Type::AstNode.new(:SELECT, trec)
      join_node = RDL::Type::AstNode.new(:JOIN, arg_type)
      select_node.insert join_node
      return select_node
    when RDL::Type::AstNode
      raise "Expected SELECT node" unless trec.op == :SELECT
      join_node = trec.find_one :JOIN
      unless join_node
        join_node = RDL::Type::AstNode.new(:JOIN, arg_type)
        trec.insert join_node
      else
        joined = RDL::Type::UnionType.new(join_node.val, arg_type)
        join_node.val = joined
      end
      return trec
    else
      raise "unexpected type #{trec}"
    end
  end

  def self.group_output_type(trec, targs)
    raise RDL::Typecheck::StaticTypeError, "group called without arguments" unless targs.size > 0
    col_names = []
    targs.each { |arg|
      raise RDL::Typecheck::StaticTypeError, "Unexpected group arg type #{arg}" unless (arg.val.class == Symbol || arg.val.class == String)
      # TODO: decide if column names matter in typecheck? AR doesn't issue any errors
      col_names << arg.val.to_sym
    }
    case trec
    when RDL::Type::SingletonType
      group_node = RDL::Type::AstNode.new(:GROUP, col_names)
      select_node = RDL::Type::AstNode.new(:SELECT, trec)
      select_node.insert group_node
      return select_node
    when RDL::Type::AstNode
      raise RDL::Typecheck::StaticTypeError, "Expected a SELECT node" unless trec.op == :SELECT
      group_node = trec.find_one :GROUP
      unless group_node
        group_node = RDL::Type::AstNode.new(:GROUP, [])
        trec.insert group_node
      end
      group_node.val = group_node.val + col_names
      return trec
    when RDL::Type::GenericType
      # TODO: not sure why I am getting a GenericType of ActiveRecord_Relation here?
      # We are losing AST information because of this even though the base class makes it work
      group_node = RDL::Type::AstNode.new(:GROUP, col_names)
      select_node = RDL::Type::AstNode.new(:SELECT, trec.params[0])
      select_node.insert group_node
      return select_node
    else
      raise "unexpected type #{trec}"
    end
  end

  def self.select_output_type(trec, targs)
    raise RDL::Typecheck::StaticTypeError, ".select called without arguments" unless targs.size > 0
    case trec
    when RDL::Type::SingletonType
      col_node = RDL::Type::AstNode.new(:COLUMNS, targs)
      select_node = RDL::Type::AstNode.new(:SELECT, trec)
      select_node.insert col_node
      return select_node
    when RDL::Type::AstNode
      raise RDL::Typecheck::StaticTypeError, "Expected a SELECT node" unless trec.op == :SELECT
      col_node = trec.find_one :COLUMNS
      unless col_node
        col_node = RDL::Type::AstNode.new(:COLUMNS, [])
        trec.insert col_node
      end
      col_node.val = col_node.val + targs
      return trec
    else
      raise "unexpected type #{trec}"
    end
  end

  def self.order_output_type(trec, targs)
    # TODO: we can do better type checking here for the order method
    case trec
    when RDL::Type::AstNode
      raise RDL::Typecheck::StaticTypeError, "Expected a SELECT node" unless trec.op == :SELECT
      order_node = RDL::Type::AstNode.new(:ORDER, targs[0])
      trec.insert order_node
      return trec
    else
      raise "unexpected type #{trec}"
    end
  end

  def self.limit_output_type(trec, targs)
    case trec
    when RDL::Type::AstNode
      raise RDL::Typecheck::StaticTypeError, "Expected a SELECT node" unless trec.op == :SELECT
      limi_node = RDL::Type::AstNode.new(:LIMIT, targs[0])
      trec.insert limi_node
      return trec
    else
      raise "unexpected type #{trec}"
    end
  end

  def self.plus_output_type(trec, targs)
    typs = []
    [trec, targs[0]].each { |t|
      case t
      when RDL::Type::AstNode
        raise "Expected SELECT node." unless t.op == :SELECT
        typs << t.val
      else
        raise "unexpected type #{t}"
      end
    }
    RDL::Type::GenericType.new(RDL::Type::NominalType.new(Array), RDL::Type::UnionType.new(*typs))
  end

  def self.count_input(trec, targs)
    hash_type = rec_to_schema_type(trec, targs).elts
    typs = []
    hash_type.each { |k, v|
      if v.is_a?(RDL::Type::FiniteHashType)
        ## will reach this with joined tables, but we're only interested in column names
        v.elts.each { |k1, v1|
          typs << RDL::Type::SingletonType.new(k1) unless v1.is_a?(RDL::Type::FiniteHashType) ## potentially two dimensions in joined table
        }
      else
        typs << RDL::Type::SingletonType.new(k)
      end
    }
    return RDL::Type::UnionType.new(*typs)
  end
end