# frozen_string_literal: true

FactoryBot.define do
  factory :tag do
    sequence(:oligo) { |n| ['A', 'C', 'G', 'T', 'A', 'C', 'G', 'T', n].shuffle.join }
    sequence(:group_id) { |n| n }
    tag_set

    factory :ont_tag do
      association(:tag_set, factory: :ont_tag_set)
    end

    factory :hidden_tag do
      association(:tag_set, factory: :hidden_tag_set)
    end

    factory :tag_with_taggables do
      transient do
        taggables_count { 3 }
      end

      after(:create) do |tag, evaluator|
        create_list(:tag_taggable, evaluator.taggables_count, tag: tag)
      end
    end
  end
end
