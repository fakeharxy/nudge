require 'rails_helper'

RSpec.describe Tag, type: :model do
  before(:each) do
    @bob = Note.create!
    @bob.add_primary_tag = "hello"
  end

  it 'has default importance of 5' do
    expect(@bob.primary_tag.importance).to eq(5)
  end

  it 'does not overwrite existing importance' do
    @mike = Note.create!
    @bob.primary_tag.set_importance = 7
    @mike.add_primary_tag = "hello"
    expect(@mike.primary_tag.importance).to eq(7)
  end

end
