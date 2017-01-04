require "mongo_http_sync/version"

module MongoHTTPSync
  autoload :MongoImporter,   'mongo_http_sync/mongo_importer'
  autoload :MongoidImporter, 'mongo_http_sync/mongoid_importer'
  autoload :Parser,          'mongo_http_sync/parser'
  autoload :Entity,          'mongo_http_sync/entity'
end
