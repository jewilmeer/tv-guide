require 'spec_helper'

describe Program do
  describe "#update name" do
    let(:episode) { create :episode, program: program }
    let(:program) { create(:program) }

    it "also updates the program name of associated episodes" do
      expect{ program.update_attribute(:name, 'changed') }.to \
        change(episode, :program_name)
    end

    it "does not update the episode if the name is unchanged" do
      expect{ program.update_attribute(:max_season_nr, 99) }.not_to \
        change(episode, :program_name)
    end
  end

  describe "slugs" do
    context "default behaviour" do
      let(:program) { Program.new name: 'How its made' }
      it "generates a slug" do
        expect { program.save }.to change(program, :slug).to('how-its-made')
      end
    end

    context "with colliding slug" do
      let(:program) { Program.new name: 'How its made', first_aired: DateTime.new(2007) }
      it "generates an alternative slug if a colliding slug exists" do
        Program.create(name: 'How its made') # create collision
        expect { program.save }.to change(program, :slug).to('how-its-made-2007')
      end
    end
  end
end
