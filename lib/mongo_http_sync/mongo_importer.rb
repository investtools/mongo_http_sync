require 'mongo_http_sync/importer'

module MongoHTTPSync
  class MongoImporter

    include Importer

    protected

    def find_last_updated_doc
      @output.find({}, sort: { updated_at: -1 }, limit: 1).first
    end

    def upsert(json)
      @output.find(_id: json['_id']).update_one(json, upsert: true)
    end

  end
end
