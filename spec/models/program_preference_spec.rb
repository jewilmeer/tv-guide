require 'spec_helper'

describe ProgramPreference do
  let(:program_preference) { create :full_hd_search_term }

  it { should belong_to :search_term_type }
  it { should belong_to :user }
  it { should belong_to :program }

  it { should validate_presence_of :search_term_type_id }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :program_id }
end

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

