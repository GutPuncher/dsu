# frozen_string_literal: true

require 'active_model'
require 'securerandom'
require_relative '../support/descriptable'
require_relative '../validators/description_validator'

module Dsu
  module Models
    class Entry
      include ActiveModel::Model
      include Support::Descriptable

      validates_with Validators::DescriptionValidator, fields: [:description]

      attr_reader :description

      def initialize(description:)
        raise ArgumentError, 'description is nil' if description.nil?
        raise ArgumentError, 'description is the wrong object type' unless description.is_a?(String)
        raise ArgumentError, 'description is blank' if description.blank?

        self.description = description
      end

      class << self
        def valid?(description:)
          description = clean_description(description)
          !(description.blank? || description[0] == '#')
        end

        def clean_description(description)
          return if description.nil?

          description.strip.gsub(/\s+/, ' ')
        end
      end

      def description=(description)
        @description = self.class.clean_description description
      end

      def to_h
        { description: description }
      end

      # Override == and hash so that we can compare Entry objects based
      # on description alone. This is useful for comparing entries in
      # an array, for example.
      def ==(other)
        return false unless other.is_a?(Entry)

        description == other.description
      end
      alias eql? ==

      def hash
        description.hash
      end
    end
  end
end
