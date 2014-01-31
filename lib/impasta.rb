require 'impasta/version'

class Impasta
  def initialize klass = nil, instantiate = true
    @__impasta_caller__  = caller

    if klass.is_a? Module then
      @__impasta_class__ = klass
      if klass.is_a?(Class) && instantiate then
        @__impasta_instance__ = klass.new
        @__impasta_name__  = "#<#{self.class}:#{@__impasta_instance__}>"
      else
        @__impasta_name__  = "#<#{self.class}:(#{klass.class})#{klass}>"
      end
    elsif klass.is_a? String then
      @__impasta_name__  = "#<#{self.class}:#{klass}>"
      @__impasta_nick__  = klass
    elsif klass.nil? then
      @__impasta_name__  = "#<#{self.class}:#{@__impasta_caller__.first}>"
    else
      @__impasta_instance__ = klass
      @__impasta_class__    = klass.class

      @__impasta_name__  = "#<#{self.class}:#{@__impasta_instance__}>"
    end
  end

  def method_missing name, *args, &block
    (@__impasta_methods__ ||= Array.new) << [name, args, block]

    if @__impasta_instance__.nil? && @__impasta_klass__.nil? then
      self
    elsif @__impasta_instance__ && @__impasta_instance__.respond_to?(name) then
      self
    elsif @__impasta_klass__ && @__impasta_klass__.method_defined?(name) then
      self
    else
      begin
        super
      rescue NoMethodError => error
        raise ImpastaNoMethodError.new self, error
      end
    end
  end

  def to_s
    @__impasta_name__
  end

  def impasta_inspect
    impasta_dump.map do |var|
      text << "#{var}: #{instance_variable_get(var)}\n" if var.to_s =~ /impasta/
      text
    end
  end

  def impasta_dump
    instance_variables.inject(Hash.new) do |dump, var|
      name = var.to_s.match(/@__impasta_(.*)__/)
      dump[name.captures.first.to_sym] = instance_variable_get(var) if name
      dump
    end
  end

  class ImpastaNoMethodError < NoMethodError
    def initialize impasta, parent_exception
      @impasta, @parent_exception = impasta, parent_exception
      @custom_message = "invalid message `#{method_info}' for #{object_info}"
    end
    attr :impasta, :parent_exception, :custom_message

    def custom_backtrace
      parent_exception.backtrace[1..-1]
    end

    alias_method :super_message, :message
    alias_method :message, :custom_message
    alias_method :super_backtrace, :backtrace
    alias_method :backtrace, :custom_backtrace

    def object_info
      if object.is_a?(Class) then
        object.name
      elsif object.is_a?(String)
        "Imposter object `#{object}' defined at `#{definition}'"
      else
        "instance of `#{object.class} < #{object.class.superclass}'"
      end
    end

    def method_info
      if method_name then
        info =  "`#{method_name}'"
        info << " with args: #{args}" if args
        if block then
          info << args ? ' with' : ' and'
          info << " block: #{block.inspect}"
        end
        info
      else
        parent_exception.message.gsub /impasta/, dump(:class).to_s
      end
    end

    def method_name
      bad_message.first
    end

    def block_info
      block.inspect
    end

    def block
      bad_message.last
    end

    def bad_message
      accessed_methods.last
    end

    def definition
      dump(:caller).first
    end

    def accessed_methods
      dump(:methods) || Array.new
    end

    def object
      dump(:instance) || dump(:class) || dump(:nick) || dump(:name)
    end

    def dump key = nil
      @dump ||= impasta.impasta_dump
      key ? @dump[key] : @dump
    end
  end

end
