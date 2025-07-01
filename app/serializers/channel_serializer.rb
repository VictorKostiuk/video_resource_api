class ChannelSerializer
  include JSONAPI::Serializer
  attributes :id, :title, :description

  attribute :posts_count do |channel|
    channel.posts.count
  end
end
