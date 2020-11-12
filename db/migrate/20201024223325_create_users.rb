class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, null: false

      t.integer :oauth_provider

      t.string :oauth_user_id
      t.string :oauth_user_name
      t.string :oauth_user_picture
      t.string :ouath_refresh_token

      t.timestamps
    end

    add_index(:users, :email, :oauth_provider, unique: true)
  end
end
