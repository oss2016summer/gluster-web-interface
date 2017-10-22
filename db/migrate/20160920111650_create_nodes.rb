class CreateNodes < ActiveRecord::Migration[5.1]
  def change
    create_table :nodes do |t|

      t.string :host_name
      t.string :host_ip, unique: true
      t.string :user_name
      t.string :user_password

      t.timestamps null: false
    end
  end
end
