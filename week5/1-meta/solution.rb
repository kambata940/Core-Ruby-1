class Object
  def define_singleton_class
    class << self
      self
    end
  end

  def define_singleton_method(name, &block)
    singleton_class.send(:define_method, name, &block)
  end
end

class String
  def to_proc
    Proc.new do |part|
      split(".").each do |method|
        part = part.send(method.to_sym)
      end
      part
    end
  end
end


class Module

  def cattr_reader(*class_vars)
      class_vars.each do |var| 
        define_singleton_method("#{var}"){ class_variable_get("@@#{var}")}
      end
  end

  def cattr_writter(*class_vars)
    class_vars.each do |var| 
      define_singleton_method("#{var}="){ |val| class_variable_set("@@#{var}", val)}
    end
  end

  def cattr_accessor(*class_vars)
    if block_given?
      value = yield
      class_vars.each do |var| 
        class_variable_set("@@#{var}", value)
      end
    end
      cattr_writter(*class_vars)
      cattr_reader(*class_vars)
  end

  def protected_attr_reader(*vars)
    vars.each do |var| define_method(var){ instance_variable_get("@#{var}".to_sym)}
      protected var
    end
  end

  def protected_attr_writter(*vars)
    vars.each do |var| define_method("#{var}="){ |value| instance_variable_set("@#{var}", value)}
      protected "#{var}="
    end
  end

  def protected_attr_accessor(*vars)
    protected_attr_writter(*vars)
    protected_attr_reader(*vars)
  end

  def private_attr_reader(*vars)
    vars.each do |var| define_method(var){ instance_variable_get("@#{var}")}
      private var
    end
  end

  def private_attr_writter(*vars)
    vars.each do |var| define_method("#{var}="){|value| instance_variable_set("@#{var}", value)}
    private "#{var}="
    end
  end

  def private_attr_accessor(*vars)
    private_attr_writter(*vars)
    private_attr_reader(*vars)
  end
end

class NilClass
  
  def method_missing(*args, &block)
    self
  end

  def respond_to_missing?(name, include_private = false)
    true
  end
end

class Proxy
  
  def initialize(object)
    @object = object
  end

  def method_missing(name, *args, &block)
    return super unless @object.respond_to?(name)
    @object.send(name, *args, &block)
  end
  
  def respond_to_missing?(name, include_private = false)
    @object.respond_to?(name) or super
  end
end

class Module
  
  def delegate(name, to:)
    instance_var = self.instance_variable_get(to)
    define_method(name, instance_var.class.instance_method(name))
  end
end
