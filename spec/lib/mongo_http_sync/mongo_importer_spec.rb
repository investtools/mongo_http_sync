require 'mongo_http_sync/mongo_importer'

require 'support/mongo_http_sync/importer_spec_group'

describe MongoHTTPSync::MongoImporter do
  it_behaves_like 'an importer', MongoHTTPSync::MongoImporter.new($client[:people]), :people
end