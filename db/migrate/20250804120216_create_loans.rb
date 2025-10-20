class CreateLoans < ActiveRecord::Migration[8.0]
  def change
    create_table :loans do |t|
      t.references :book, null: false, foreign_key: true
      t.references :borrower, null: false, foreign_key: true
      t.date :loan_date
      t.date :return_date
      t.date :actual_return_date
      t.string :status

      t.timestamps
    end
  end
end
