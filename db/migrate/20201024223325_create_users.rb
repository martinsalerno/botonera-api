class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, null: false

      t.integer :oauth_provider
      t.string :acccess_token
      t.string :refresh_token
      t.datetime :expiry_date

      t.timestamps
    end

    add_index(:users, :email, unique: true)
  end
end
