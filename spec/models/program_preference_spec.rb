require 'spec_helper'

describe ProgramPreference do
  let(:program_preference) { create :full_hd_search_term }

  it { should belong_to :search_term_type }
  it { should belong_to :user }
  it { should belong_to :program }

  it { should validate_presence_of :search_term_type_id }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :program_id }
  it { should validate_uniqueness_of(:program_id).scoped_to(:user_id) }

  context "instance" do
    # let(:program) { create :program }
    # let(:user) { create :user }
    # let(:search_term_type) { create :hd_search_term }
    subject { build :program_preference }

    it "should update the program counter cache on program" do
      expect{ subject.save }.to change( subject.program, :program_preferences_count).by(1)
    end
  end
end