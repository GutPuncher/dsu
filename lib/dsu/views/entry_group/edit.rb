# frozen_string_literal: true

require 'time'
require 'active_support/core_ext/numeric/time'
require_relative '../../models/entry_group'
require_relative '../../support/colorable'
require_relative '../../support/say'
require_relative '../../support/time_formatable'

module Dsu
  module Views
    module EntryGroup
      class Edit
        include Support::Colorable
        include Support::Say
        include Support::TimeFormatable

        def initialize(entry_group:, options: {})
          raise ArgumentError, 'entry_group is nil' if entry_group.nil?
          raise ArgumentError, 'entry_group is the wrong object type' unless entry_group.is_a?(Models::EntryGroup)
          raise ArgumentError, 'options is nil' if options.nil?
          raise ArgumentError, 'options is the wrong object type' unless options.is_a?(Hash)

          @entry_group = entry_group
          @options = options || {}
        end

        def call
          # Just in case the entry group is invalid, we'll
          # validate it before displaying it.
          entry_group.validate!
          render_entry_group!
        rescue ActiveModel::ValidationError
          puts "Error(s) encountered: #{entry_group.errors.full_messages}"
          raise
        end
        alias render call

        private

        attr_reader :entry_group, :options

        def render_entry_group!
          say "# Editing DSU Entries for #{formatted_time(time: entry_group.time)}"
          say('(no entries available for this day)') and return if entry_group.entries.empty?

          say ''
          say '# [SHA/COMMAND] [DESCRIPTION]'

          entry_group.entries.each do |entry|
            say "#{entry.uuid} #{entry.description.strip}"
          end

          say ''
          say '# INSTRUCTIONS:'
          say '# ADD a DSU entry: use one of the following commands: [+|a|add] ' \
              'followed by the description.'
          say '# EDIT a DSU entry: change the description.'
          say '# DELETE a DSU entry: delete the entry or replace the sha with one ' \
              'of the following commands: [-|d|delete].'
          say '# NOTE: deleting all the entries will delete the entry group file; '
          say '#       this is preferable if this is what you want to do :)'
          say '# REORDER a DSU entry: reorder the DSU entries in order preference.'
          say '#'
          say '# *** When you are done, save and close your editor ***'
        end
      end
    end
  end
end
