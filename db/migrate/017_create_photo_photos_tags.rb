class CreatePhotoPhotosTags < ActiveRecord::Migration
  def self.up
    create_table :photo_photos_tags do |t|
    end
  end

  def self.down
    drop_table :photo_photos_tags
  end
end
