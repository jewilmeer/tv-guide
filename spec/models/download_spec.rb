require 'spec_helper'

describe Download do
  let!(:episode) { create :episode }
  let(:download) { build :download, episode: episode }

  it "updates the episode upon creation" do
    expect { download.save }.to change episode, :updated_at
  end
end
