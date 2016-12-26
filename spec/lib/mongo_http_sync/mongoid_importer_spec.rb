require 'mongo_http_sync/mongoid_importer'
require 'mongoid'

require 'support/mongo_http_sync/importer'

describe MongoHTTPSync::MongoidImporter do
  PERSON_CLASS = Class.new do
    include Mongoid::Document

    store_in collection: 'people'

    field :name
    field :last_name
    field :updated_at, type: Time
  end
  it_behaves_like 'an importer', MongoHTTPSync::MongoidImporter.new(PERSON_CLASS), :people
end