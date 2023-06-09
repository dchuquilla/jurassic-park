# frozen_string_literal: true

# Dinosaur model
class Dinosaur < ApplicationRecord
  # To ensure that each dinosaur is either an herbivore or a carnivore
  belongs_to :cage

  enum diet_type: %i[HERBIVORE CARNIVORE].freeze
  enum species: %i[TYRANNOSAURUS VELOCIRAPTOR SPINOSAURUS MEGALOSAURUS BRACHIOSAURUS
                   STEGOSAURUS ANKYLOSAURUS TRICERATOPS].freeze

  validates :name, presence: true
  validates :species, presence: true
  validates :diet_type, presence: true

  validate :carnivores_same_species
  validate :herbivores_different_cage
  validate :carnivores_different_cage

  # should be filterable on species
  scope :filter_by_species, ->(species) { where(species: species) }
  # should be filterable on diet
  scope :filter_by_diet_type, ->(diet_type) { where(diet_type: diet_type) }

  after_create :increment_cage_num_dinosaurs

  private

  # To ensure that carnivores can only be in a cage with other dinosaurs of the same species
  def carnivores_same_species
    print "\nquery.exists?",
          Dinosaur.filter_by_diet_type(:CARNIVORE.to_s).filter_by_species(species.to_s).exists?

    if diet_type == :CARNIVORE.to_s && Dinosaur.filter_by_diet_type(diet_type.to_s).filter_by_species(species.to_s).exists?
      return
    end

    errors.add(:cage, 'Carnivores of the diferent species cannot be in the same cage')
  end

  # To ensure that herbivores cannot be in the same cage as carnivores
  def herbivores_different_cage
    return unless diet_type == :HERBIVORE && cage.dinosaurs.where(diet_type: :CARNIVORE).exists?

    errors.add(:cage, 'Herbivores cannot be in the same cage as carnivores')
  end

  # To ensure that herbivores cannot be in the same cage as carnivores
  def carnivores_different_cage
    return unless diet_type == :CARNIVORE && cage.dinosaurs.where(diet_type: :HERBIVORE).exists?

    errors.add(:cage, 'Herbivores cannot be in the same cage as carnivores')
  end

  def increment_cage_num_dinosaurs
    cage.increment!(:num_dinosaurs)
  end
end
