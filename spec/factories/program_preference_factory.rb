# == Schema Information
#
# Table name: program_preferences
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  program_id          :integer
#  download            :boolean          default(TRUE)
#  search_term_type_id :integer          default(1)
#  created_at          :datetime
#  updated_at          :datetime
#

FactoryGirl.define do
  factory :program_preference do
    download true

    search_term_type
    program
    user
  end
end
