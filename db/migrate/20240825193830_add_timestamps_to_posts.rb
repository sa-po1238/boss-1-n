class AddTimestampsToPosts < ActiveRecord::Migration[6.1]
  def change
    add_timestamps :posts, null: false, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
