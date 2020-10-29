class CreateKeybords < ActiveRecord::Migration[6.0]
  def change
    create_table :keyboards do |t|
      t.integer :user_id, null: false
      t.string :name, null: false
      t.jsonb :keys, null: false, default: {}
    end

    add_index(:keyboards, %i[user_id name], unique: true)
  end
end
