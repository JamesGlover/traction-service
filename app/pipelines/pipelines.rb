# frozen_string_literal: true

# Pipelines
module Pipelines
  # InstanceMethodCreator
  module InstanceMethodCreator
    def create_instance_method(key, &block)
      self.class.send(:define_method, key, block)
    end
  end

  def self.configure(pipelines)
    Configuration.new(pipelines).tap do |configuration|
      configuration.pipelines.each do |pipeline|
        # TODO: how do I use the create_instance_method method
        self.class.send(:define_method, pipeline, proc { configuration.send(pipeline) })
      end
    end
  end

  # Requestor - behaviour for pipeline requests
  module Requestor
    # Model - behaviour for pipeline requests model
    module Model
      extend ActiveSupport::Concern

      include Material

      included do
        has_one :request, class_name: '::Request', as: :requestable, dependent: :nullify
        has_one :sample, through: :request

        delegate :name, to: :sample, prefix: :sample

        validates(*to_s.deconstantize.constantize.attributes, presence: true)
      end
    end

    # Model - behaviour for pipeline requests factory
    module Factory
      extend ActiveSupport::Concern

      include ActiveModel::Model

      included do
        validate :check_requests
      end

      # Model ClassMethods
      module ClassMethods
        def pipeline
          @pipeline ||= name.to_s.deconstantize
        end

        def request_model
          @request_model ||= "#{pipeline}::Request".constantize
        end
      end

      def initialize(attributes = [])
        build_requests(attributes)
      end

      def requests
        @requests ||= []
      end

      def requestables
        requests.collect(&:requestable)
      end

      def save
        return false unless valid?

        requests.collect(&:save)
        true
      end

      def build_requests(attributes)
        attributes.each do |request|
          sample_attributes = request.extract!(:name, :external_id, :species)
          requests << ::Request.new(requestable:
            self.class.request_model.new(request.merge!(tube: Tube.new)),
                                    sample: Sample.find_or_initialize_by(sample_attributes))
        end
      end

      def check_requests
        if requests.empty?
          errors.add('requests', 'there were no requests')
          return
        end

        requests.each do |request|
          next if request.valid?

          request.errors.each do |k, v|
            errors.add(k, v)
          end
        end
      end
    end

    # Controller - behaviour for pipeline requests factory
    module Controller
      extend ActiveSupport::Concern

      # Model ClassMethods
      module ClassMethods
        def module_path
          @module_path ||= name.to_s.deconstantize
        end

        def pipeline
          @pipeline ||= module_path.split('::').last
        end

        def pipeline_const
          @pipeline_const ||= pipeline.constantize
        end

        def request_factory_model
          @request_factory_model ||= "::#{pipeline}::RequestFactory".constantize
        end

        def request_model
          @request_model ||= "::#{pipeline}::Request".constantize
        end

        def resource_model
          "#{module_path}::RequestResource".constantize
        end
      end

      def create
        if request_factory.save
          render json: body, status: :created
        else
          render json: { data: { errors: @request_factory.errors.messages } },
                 status: :unprocessable_entity
        end
      end

      def request_factory
        @request_factory ||= self.class.request_factory_model.new(params_names)
      end

      def resources
        @resources = request_factory.requestables.map do |request|
          self.class.resource_model.new(request, nil)
        end
      end

      def body
        @body ||= JSONAPI::ResourceSerializer.new(
          self.class.resource_model
        ).serialize_to_hash(resources)
      end

      def destroy
        pipeline_request.destroy
        head :no_content
      rescue StandardError => e
        render json: { data: { errors: e.message } }, status: :unprocessable_entity
      end

      def pipeline_request
        @pipeline_request = (params[:id] && self.class.request_model.find_by(id: params[:id]))
      end

      def params_names
        params.require(:data).require(:attributes)[:requests].map do |param|
          param.permit(*self.class.pipeline_const.attributes, :name, :external_id, :species).to_h
        end
      end
    end
  end
end
