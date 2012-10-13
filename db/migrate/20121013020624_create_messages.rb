class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :letter
      t.references :author, null: false
      t.references :project
      t.references :volunteer
      t.string :from_address, null: false
      t.string :to_address, null: false
      t.string :payment_token
      t.string :transaction_id
      t.boolean :confirmed_payment, default: false

      t.timestamps
    end
    add_index :messages, :author_id
    add_index :messages, :project_id
    add_index :messages, :volunteer_id
  end
end
