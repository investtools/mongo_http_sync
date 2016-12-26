$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "mongo_http_sync"

require 'mongoid'

Mongo::Logger.level = Logger::WARN
Mongoid.configure { |config| config.connect_to('mongo_http_sync_test')  }
$client = Mongoid.default_client


RSpec.configure do |config|

  config.before :suite do
    $client.collections.each { |c| c.find.delete_many }
  end

  config.after :each do
    $client.collections.each { |c| c.find.delete_many }
  end

end
