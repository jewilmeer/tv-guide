require 'spec_helper'

describe Network do
  it { expect(subject).to validate_presence_of :name }
end
