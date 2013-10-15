class CreateHavenotResultKeywords < ActiveRecord::Migration
  def self.up
    create_table :havenot_result_keywords do |t|
    end
  end

  def self.down
    drop_table :havenot_result_keywords
  end
end
