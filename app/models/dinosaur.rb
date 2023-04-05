# frozen_string_literal: true

# Dinosaur model
class Dinosaur < ApplicationRecord
  # To ensure that each dinosaur is either an herbivore or a carnivore
  belongs_to :cage

  enum diet: %i[HERBIVORE CARNIVORE].freeze
  enum species: %i[TYRANNOSAURUS VELOCIRAPTOR SPINOSAURUS MEGALOSAURUS BRACHIOSAURUS
                   STEGOSAURUS ANKYLOSAURUS TRICERATOPS].freeze

  validates :name, presence: true
  validates :species, presence: true
  validates :diet, presence: true

  validate :carnivores_same_species
  validate :herbivores_different_cage

  # should be filterable on species
  scope :filter_by_species, ->(species) { where(species: species) }
  # should be filterable on diet
  scope :filter_by_diet, ->(diet) { where(diet: diet) }

  private

  # To ensure that carnivores can only be in a cage with other dinosaurs of the same species
  def carnivores_same_species
    if diet_type == 'carnivore' && cage.dinosaurs.where(diet_type: 'carnivore',
                                                        species: species).exists?
      errors.add(:species, 'Carnivores of the same species cannot be in the same cage')
    end
  end

  # To ensure that herbivores cannot be in the same cage as carnivores
  def herbivores_different_cage
    return unless diet_type == 'herbivore' && cage.dinosaurs.where(diet_type: 'carnivore').exists?

    errors.add(:cage, 'Herbivores cannot be in the same cage as carnivores')
  end
end
