FactoryBot.define do
  factory :user do
    firstname { 'Sándor' }
    lastname  { 'Hentes' }

    sequence(:screen_name) { |n| "screen_name_sanyi_#{n}" }
    sequence(:nickname) { |n| "nickname_sanyi#{n}" }
    sequence(:email) { |n| "sanyi_#{n}@example.org" }
    sequence(:cell_phone) { |n| "66677788#{n}" }
    sequence(:neptun) do |n|
      random_character = (n + 48).chr(Encoding::UTF_8)
      "AAAAA#{random_character}"
    end
    auth_sch_id { SecureRandom.uuid }

    trait :with_primary_membership do
      svie_member_type { 'RENDESTAG' }
      after(:build) do |user|
        user.svie_primary_membership = create(:membership, :for_svie_group, user: user).id
      end
    end

    trait :who_delegated do
      delegated { true }

      with_primary_membership
    end
  end
end
