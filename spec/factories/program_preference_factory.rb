FactoryGirl.define do
  factory :program_preference do
    download true

    search_term_type
    program
    user
  end
end