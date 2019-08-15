class CreateFoods < ActiveRecord::Migration[6.0]
  def change
    create_table :foods do |t|
      t.string :food_name
      t.integer :kitchen_food_id
      t.integer :quantity

      t.timestamps
    end
  end
end
