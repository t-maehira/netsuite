class CreateOrderLogs < ActiveRecord::Migration
  def change
    create_table :order_logs do |t|
      t.string  :record_id,  null: false, index: true
      t.string  :record_type,      null: false
      t.string  :tranid,    null: false
      t.string  :approved,  null: true,  default: nil
      t.timestamps null: false
    end
  end
end
