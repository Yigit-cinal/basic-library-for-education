class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :genre
      t.string :category
      t.integer :year
      t.integer :page_count
      t.string :image_url

      t.timestamps
    end
  end
end
