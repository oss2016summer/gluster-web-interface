class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|

      t.string :host_name
      t.string :host_ip
      t.integer :host_port
      t.string :user_name
      t.string :user_password
      
      t.timestamps null: false
    end
  end
end
