FactoryBot.define do
  factory :cage do
    capacity { rand(1..10) }
    sequence(:name) { |n| "Cage #{n}" }
    power_status { :active }
    num_dinosaurs { 0 }
    # Define a trait for a powered down cage
    trait :powered_down do
      power_status { :down }
    end
  end
end
