require 'mongoid'
require 'active_support/concern'

module MongoHTTPSync
  module ExportableDocument
    extend ActiveSupport::Concern
    include Mongoid::Timestamps::Updated

    included do
      scope :updated_since, ->(time) { where(updated_at: { '$gte' => time }) }
      index updated_on: 1
    end
  end
end
