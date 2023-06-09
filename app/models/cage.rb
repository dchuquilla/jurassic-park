# frozen_string_literal: true

# Cage model
class Cage < ApplicationRecord
  # To ensure that each dinosaur is either an herbivore or a carnivore
  has_many :dinosaurs

  enum power_status: %i[down active].freeze

  validates :capacity, presence: true, numericality: { greater_than: 0 }
  validates :power_status, presence: true
  validate :max_capacity
  validate :no_power_down_on_dinosaurs_withn
  validate :no_move_dinosaurs_to_power_on_cage

  # should be filterable on power_status
  scope :filter_by_power_status, ->(status) { where(power_status: status) }

  # Must be able to query a listing of dinosaurs in a specific cage
  def dinosaurs_in_cage
    dinosaurs.pluck(:name)
  end

  private

  # To add a maximum capacity for cages
  def max_capacity
    return unless num_dinosaurs > capacity

    errors.add(:capacity, 'Cage is at maximum capacity')
  end

  # To ensure that cages cannot be powered off if they contain dinosaurs
  def no_power_down_on_dinosaurs_withn
    return if num_dinosaurs.zero?

    errors.add(:power_status, 'Cages cannot be powered off if they contain dinosaurs')
  end

  # To ensure that dinosaurs cannot be moved into a cage that is powered down
  def no_move_dinosaurs_to_power_on_cage
    return unless power_status == :down

    errors.add(:power_status, 'Dinosaurs cannot be moved into a cage that is powered down')
  end
end
