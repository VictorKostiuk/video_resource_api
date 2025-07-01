class PostSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :description, :created_at, :thumbnail
end
