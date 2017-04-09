class CreateMetrics < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.string :ip
      t.decimal :rtt, precision: 10, scale: 3
      t.integer :transmitted
      t.integer :received
      t.datetime :collected_at

      t.timestamps null: false
    end
  end
end
