class CreatePhotoTags < ActiveRecord::Migration
  def self.up
    create_table :photo_tags do |t|
    end
  end

  def self.down
    drop_table :photo_tags
  end
end
