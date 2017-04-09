class CreateInstances < ActiveRecord::Migration
  def change
    create_table :instances do |t|
      t.string :ip

      t.timestamps null: false
    end
  end
end
