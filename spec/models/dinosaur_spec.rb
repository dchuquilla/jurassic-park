require 'rails_helper'

RSpec.describe Dinosaur, type: :model do
  let(:cage) { create(:cage) }
  let(:dinosaur) { create(:dinosaur, cage: cage) }

  describe 'associations' do
    it 'is invalid without a name' do
      dinosaur = build(:dinosaur, name: nil)
      expect(dinosaur).not_to be_valid
    end
  end

  describe 'validations' do
    it 'validates presence of name' do
      expect(dinosaur).to validate_presence_of(:name)
    end

    it 'validates presence of species' do
      expect(dinosaur).to validate_presence_of(:species)
    end

    it 'validates presence of diet type' do
      expect(dinosaur).to validate_presence_of(:diet_type)
    end

    context 'when herbivore' do
      before { dinosaur.diet_type = :HERBIVORE }

      it 'is valid if no carnivores in cage' do
        expect(dinosaur).to be_valid
      end

      it 'is invalid if there are carnivores in cage' do
        expect do
          dinosaur.cage.dinosaurs << create(:dinosaur, diet_type: 'carnivore')
        end.to raise_exception(ArgumentError)
      end
    end

    context 'when carnivore' do
      before { dinosaur.diet_type = :CARNIVORE }

      it 'is invalid if same species carnivores in cage' do
        expect(dinosaur).not_to be_valid
      end
    end
  end
end
