require 'rails_helper'

RSpec.describe Note, type: :model do
  before(:each) do
    @bob = Note.create! 
  end

  subject {
    described_class.new()
  }

  it 'is valid' do
    expect(subject).to be_valid
  end

  it 'accepts a primary tag' do
    @bob.add_primary_tag = "hello"
    expect(@bob.get_primary_tag_name).to eq("hello")
  end

  it 'accepts multiple secondary tags' do
    @bob.add_secondary_tags = "hello, this, tags"
    expect(@bob.get_all_tag_names).to eq(["hello", "this", "tags"])
  end

  it 'can return both primary and secondary tags' do
    @bob.add_secondary_tags = "hello, this, tags"
    @bob.add_primary_tag = "mike"
    expect(@bob.get_all_tag_names).to eq(["hello", "this", "tags", "mike"])
  end

  it 'deletes a tag when the note is deleted' do
    @bob.add_secondary_tags = "hello"
    @bob.destroy_with_tags
    expect(Tag.all).to eq([])
  end

  it 'does not delete a tag if connected to another note' do
    mike = Note.create!
    @bob.add_secondary_tags = "hello"
    mike.add_secondary_tags = "hello"
    @bob.destroy_with_tags
    expect(Tag.all).to_not eq([])
    mike.destroy_with_tags
    expect(Tag.all).to eq([])
  end

end
