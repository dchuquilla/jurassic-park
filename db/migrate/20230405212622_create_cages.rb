# frozen_string_literal: true

# Cretare cages migration
class CreateCages < ActiveRecord::Migration[7.0]
  def change
    create_table :cages do |t|
      t.string :name, null: false
      t.integer :capacity
      t.integer :power_status, default: 0, null: false
      t.integer :num_dinosaurs, default: 0, null: false
      t.timestamps
    end
  end
end
