require 'grape-entity'

module MongoHTTPSync
  class Entity < Grape::Entity
    expose :_id, :updated_at
  end
end
