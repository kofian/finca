class CreateWireTransfers < ActiveRecord::Migration[5.0]
  def up
    create_table :wire_transfers do |t|
      #t.references :acct_transaction, index: true, foreign_key: true, limit: 8
     t.integer "acct_transaction_id", limit: 8
     t.string  "recipient_name", limit: 50, null: false
     t.text    "address", limit: 255, null: false
     t.string "city", limit: 50
     t.string "state", limit: 50, null: false
     t.string "country", limit: 50, null: false
     t.string "phone", limit: 13, null: false
     t.integer "bank_account", limit: 8, null: false
     t.string "bank_name", limit: 50, null: false
     t.string "bank_country", limit: 50, null: false
     t.string "routing", limit: 20, null: false
     t.string "status", default: "pending"
     t.text "description", limit: 255, null: false
     t.datetime "date",   null: false
     t.decimal "credited", precision: 10, scale: 2, null: false

    end
    add_index "wire_transfers",["acct_transaction_id"], name: "fk_wire_transactions_types1_idx"
  end
  def down
    drop_table :wire_transfers
  end
end
