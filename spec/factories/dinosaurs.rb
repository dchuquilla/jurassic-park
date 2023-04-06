FactoryBot.define do
  factory :dinosaur do
    sequence(:name) { |n| "Dinosaur #{n}" }
    species { :TYRANNOSAURUS }
    diet_type { :CARNIVORE }
    association :cage, factory: :cage
  end
end
