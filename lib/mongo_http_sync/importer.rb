require 'http'

require 'mongo_http_sync/parser'

module MongoHTTPSync
  module Importer

    def initialize(output)
      @output = output
    end

    def import(url, key: 'id')
      last_updated_doc = find_last_updated_doc
      newest_update = last_updated_doc['updated_at'] unless last_updated_doc.nil?
      unless newest_update.nil?
        url = append_query_param(url, 'updated_since', newest_update.utc.strftime('%Y-%m-%d %H:%M:%S.%L UTC'))
      end
      puts url
      Parser.parse(HTTP.get(url).body) do |json|
        json['_id'] = json.delete(key)
        upsert(json)
      end
    end

    protected

    def append_query_param(url, key, value)
      uri =  URI.parse(url)
      new_query_ar = URI.decode_www_form(String(uri.query)) << [key, value]
      uri.query = URI.encode_www_form(new_query_ar)
      url = uri.to_s
    end
  end
end
