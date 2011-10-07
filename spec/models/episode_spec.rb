require 'spec_helper'

describe Episode do
  subject { create(:episode) }
  context "creation" do
    it { should be_valid }
  end

  describe 'associations' do
    it { should belong_to(:program) }
    it { should belong_to(:image) }
    it { should have_many(:interactions) }
    it { should have_many(:downloads) }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :season_nr }
    it { should validate_presence_of :program_id }
    it { should validate_presence_of :nr }
  end
end