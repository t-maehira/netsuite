class CreateOrderLogs < ActiveRecord::Migration
  def change
    create_table :order_logs do |t|
      t.string  :order_id,  null: false, index: true
      t.boolean :approved,  null: false,  default: "0"
      t.string  :type,      null: false

      t.timestamps null: false
    end
  end
end
