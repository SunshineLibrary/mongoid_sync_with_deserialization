# encoding: UTF-8

require 'rails'
require 'mongoid'

module ::Mongoid
  module SyncWithDeserialization
    extend ActiveSupport::Concern

    included do
      cattr_accessor :deserialization_parsers
      before_save :deserialization_before_sync

      def deserialization_before_sync
        Utils.load_parsers self.class

        self.class.deserialization_parsers.each do |_field, _field_parser|
          _v = self.read_attribute(_field)
          if _v.is_a?(String)
            _v = _field_parser.call(_v) rescue _v
            self.write_attribute(_field, _v)
          end
          Rails.logger.info "#{_field} : #{_field_parser} : #{_v}" if $IS_DEBUG_SyncWithDeserialization
        end
      end
    end


    module Utils
      def self.load_parsers klass
        return false if not klass.deserialization_parsers.blank?
        klass.deserialization_parsers ||= {}

        klass.fields.each do |_field_k, _field_v|
          # Add more data parsers
          if [Time, DateTime].include? _field_v.type
            klass.deserialization_parsers[_field_k] = proc {|v| Time.zone.parse(v) }
          end
        end

      end
    end

  end
end
