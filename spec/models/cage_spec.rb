require 'rails_helper'

RSpec.describe Cage, type: :model do
  describe 'validations' do
    let(:cage) { build(:cage) }

    it 'has a valid factory' do
      expect(cage).to be_valid
    end

    it 'is invalid without a max capacity' do
      cage.capacity = 0
      expect(cage).not_to be_valid
    end

    it 'is invalid if capacity is not a positive number' do
      cage.capacity = -1
      expect(cage).not_to be_valid
    end

    it 'is invalid without a power status' do
      cage.power_status = nil
      expect(cage).not_to be_valid
    end

    it 'is invalid if power status is not :down or :active' do
      expect do
        cage.power_status = :invalid_status
      end.to raise_exception(ArgumentError)
    end

    it 'is invalid if the cage is at maximum capacity' do
      create_list(:dinosaur, 5, cage: cage)
      expect(cage).not_to be_valid
    end

    it 'is invalid if cage is powered down and contains dinosaurs' do
      cage2 = create(:cage)
      create(:dinosaur, cage: cage2)

      cage2.power_status = :down
      expect(cage2).not_to be_valid
    end

    it 'is invalid to move dinosaurs into a powered down cage' do
      cage.power_status = :active
      create(:dinosaur, cage: cage)
      expect(cage).not_to be_valid
    end
  end

  describe 'traits' do
    describe 'powered_down' do
      it 'sets the power_status to down' do
        cage = create(:cage, :powered_down)
        expect(cage.power_status).to eq('down')
      end
    end
  end

  describe 'scopes' do
    describe '.filter_by_power_status' do
      let!(:active_cage1) { create(:cage, power_status: :active) }
      let!(:active_cage2) { create(:cage, power_status: :active) }
      let!(:down_cage) { create(:cage, power_status: :down) }

      it 'returns cages with the specified power status' do
        expect(Cage.filter_by_power_status(:active)).to eq([active_cage1, active_cage2])
      end
    end
  end

  describe 'instance methods' do
    describe '#dinosaurs_in_cage' do
      let!(:cage) { create(:cage) }

      it 'returns an array of dinosaur names in the cage' do
        create_list(:dinosaur, 3, cage: cage)
        expect(cage.dinosaurs_in_cage).to eq(['Dinosaur 1', 'Dinosaur 2', 'Dinosaur 3'])
      end
    end
  end
end
