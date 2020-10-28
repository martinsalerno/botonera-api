class CreateSounds < ActiveRecord::Migration[6.0]
  def change
  	create_table :sounds do |t|
  	  t.integer :user_id, null: false
  	  t.string :name, null: false
  	  t.string :path, null: false
  	end

  	add_index(:sounds, [:user_id, :name], unique: true)
  	add_index(:sounds, :path, unique: true)
  end
end
