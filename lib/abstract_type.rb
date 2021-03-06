# encoding: utf-8

# Module to allow class and methods to be abstract
module AbstractType

  # Hook called when module is included
  #
  # @param [Module] descendant
  #   the module or class including AbstractType
  #
  # @return [self]
  #
  # @api private
  def self.included(descendant)
    super
    descendant.extend(ClassMethods)
    self
  end

  module ClassMethods

    # Instantiate a new object
    #
    # Ensures that the instance cannot be of the abstract type
    # and must be a descendant.
    #
    # @example
    #   object = AbstractType.new
    #
    # @return [Object]
    #
    # @api public
    def new(*)
      if superclass.equal?(Object)
        raise NotImplementedError, "#{inspect} is an abstract type"
      else
        super
      end
    end

    # Create abstract instance methods
    #
    # @example
    #   class Foo
    #     include Abstract
    #
    #     # Create an abstract instance method
    #     abstract_method :some_method
    #   end
    #
    # @param [Array<#to_s>] names
    #
    # @return [self]
    #
    # @api public
    def abstract_method(*names)
      names.each { |name| create_abstract_instance_method(name) }
      self
    end

    # Create abstract singleton methods
    #
    # @example
    #   class Foo
    #     include Abstract
    #
    #     # Create an abstract instance method
    #     abstract_singleton_method :some_method
    #   end
    #
    # @param [Array<#to_s>] names
    #
    # @return [self]
    #
    # @api private
    def abstract_singleton_method(*names)
      names.each { |name| create_abstract_singleton_method(name) }
      self
    end

  private

    # Create abstract singleton method
    #
    # @param [#to_s] name
    #   the name of the method to create
    #
    # @return [undefined]
    #
    # @api private
    def create_abstract_singleton_method(name)
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def self.#{name}(*)                                                    # def self.name(*)
          raise NotImplementedError, "\#{inspect}.#{name} is not implemented"  #   raise NotImplementedError, '\#{inspect}.name is not implemented'
        end                                                                    # end
      RUBY
    end

    # Create abstract instance method
    #
    # @param [#to_s] name
    #   the name of the method to create
    #
    # @return [undefined]
    #
    # @api private
    def create_abstract_instance_method(name)
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{name}(*)                                                                    # def name(*)
          raise NotImplementedError, "\#{self.class.inspect}##{name} is not implemented"  #   raise NotImplementedError, "\#{self.class.inspect}#name is not implemented"
        end                                                                               # end
      RUBY
    end

  end # module ClassMethods
end # module Abstract
