FactoryGirl.define do
  factory :search_term_type do
    sequence(:name) {|n| "name#{n}"}
    sequence(:code) {|n| "code#{n}"}
  end

  factory :low_res_search_term, :parent => :search_term_type do
    name 'Low Res'
    code 'low_res'
  end

  factory :hd_search_term, :parent => :search_term_type do
    name 'HD (720p)'
    code 'hd'
  end

  factory :full_hd_search_term, :parent => :search_term_type do
    name 'Full HD'
    code 'full_hd'
  end
end