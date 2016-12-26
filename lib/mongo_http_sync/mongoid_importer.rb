require 'mongo_http_sync/importer'

module MongoHTTPSync
  class MongoidImporter

    include Importer

    protected

    def find_last_updated_doc
      @output.reorder(updated_at: :desc).first
    end

    def upsert(json)
      doc = @output.where(_id: json['_id']).first
      if doc.nil?
        @output.create! json
      else
        doc.update_attributes! json
      end
    end

  end
end
