# frozen_string_literal: true

# Dinosaurs create migration
class CreateDinosaurs < ActiveRecord::Migration[7.0]
  def change
    create_table :dinosaurs do |t|
      t.string :name, null: false
      t.integer :species, null: false
      t.integer :diet_type, null: false
      t.belongs_to :cage, index: true, foreign_key: true, null: false
      t.timestamps
    end
  end
end
