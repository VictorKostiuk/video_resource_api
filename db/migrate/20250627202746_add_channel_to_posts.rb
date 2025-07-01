class AddChannelToPosts < ActiveRecord::Migration[8.0]
  def change
    add_reference :posts, :channel, null: false, foreign_key: true
  end
end
