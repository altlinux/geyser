# frozen_string_literal: true

module Api
  module Docs
    module Models
      class OutputChangelog
        # :nocov:
        include Swagger::Blocks

        swagger_schema :OutputChangelog do
          key :required, [:id, :srpm_id, :at, :name,
                          :text, :created_at, :updated_at]
          property :id do
            key :type, :integer
            key :format, :int64
            key :description, 'Changelog ID'
          end
          property :srpm_id do
            key :type, :integer
            key :format, :int64
            key :description, 'Srpm ID'
          end
          property :at do
            key :type, :string
            key :description, 'Changed at'
          end
          property :name do
            key :type, :string
            key :format, :binary
            key :description, 'Changelog name'
          end
          property :text do
            key :type, :string
            key :format, :binary
            key :description, 'Changelog text'
          end
          property :created_at do
            key :type, :string
            key :format, :'date-time'
            key :description, 'Created at in ISO8601 format'
          end
          property :updated_at do
            key :type, :string
            key :format, :'date-time'
            key :description, 'Updated at in ISO8601 format'
          end
        end
        # :nocov:
      end
    end
  end
end
