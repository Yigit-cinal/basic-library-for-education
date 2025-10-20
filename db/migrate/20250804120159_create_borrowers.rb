class CreateBorrowers < ActiveRecord::Migration[8.0]
  def change
    create_table :borrowers do |t|
      t.string :tc_no
      t.string :name
      t.string :surname
      t.string :phone
      t.string :email

      t.timestamps
    end
    add_index :borrowers, :tc_no
  end
end
