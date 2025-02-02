# frozen_string_literal: true

module Pipelines
  # Configuration - build the pipelines configuration
  class Configuration
    include InstanceMethodCreator

    # builds a configuration object
    # @param pipelines [Hash] list of all the pipelines with their respective configuration
    def initialize(pipelines)
      pipelines.with_indifferent_access.each do |key, pipeline|
        create_instance_method(key) { Item.new(key, pipeline) }
        self.pipelines << key
      end
    end

    # @return [Array] list of configuration items for each pipeline
    def pipelines
      @pipelines ||= []
    end

    # Configuration::Item
    # TODO: this needs fixing. It is being used in slightly different ways and
    # we should be able to iterate rather than map.
    class Item
      include Enumerable
      include InstanceMethodCreator

      attr_reader :children, :pipeline

      # builds a configuration item object
      # This is a recursive function for each child that is a hash it will
      # create a new Configuration::Item
      # This creates a chain of instance methods for each item in the hash
      # It also creates an attribute reader of the original hash.
      # @param children [Hash] list of all the pipelines with their respective configuration
      def initialize(pipeline, children = {})
        @children = children

        # the pipeline tells you which pipeline it belongs to without having
        # to query the class itself. I know it is only useful for tests but
        # worth it
        @pipeline = pipeline

        children.each do |key, child|
          if child.instance_of?(ActiveSupport::HashWithIndifferentAccess)
            create_instance_method(key) { Item.new(pipeline, child) }
          else
            create_instance_method(key) { child }
          end
        end
      end

      def each(&block)
        children.each(&block)
      end
    end
  end
end
