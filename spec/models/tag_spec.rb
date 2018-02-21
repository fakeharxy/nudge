require 'rails_helper'

RSpec.describe Tag, type: :model do
  before(:each) do
    @bob = Note.create!(body: "bob")
    @bob.add_primary_tag = "hello"
    @bobtag = Tag.find_by(name: "hello")
  end

  it 'has default importance of 5' do
    expect(@bob.primary_tag.importance).to eq(5)
  end

  it 'does not overwrite existing importance' do
    @mike = Note.create!(body: "mike")
    @bob.primary_tag.set_importance = 7
    @mike.add_primary_tag = "hello"
    expect(@mike.primary_tag.importance).to eq(7)
  end

  it 'can get all notes it belongs to' do
    expect(@bobtag.get_all_notes).to eq([@bob])
  end

  it 'can return number of notes' do
    @mike = Note.create!(body: "mike")
    @mike.add_secondary_tags = "hello"
    @tim = Note.create!(body: "tim")
    @tim.add_primary_tag = "hello"
    expect(Tag.find_by(name:"hello").note_count).to eq(3)
  end

  it 'can get multiple notes(with secondary tags)' do
    @trey = Note.create!
    @trey.add_primary_tag = "hello"
    @mike = Note.create!
    @mike.add_secondary_tags = "hello"
    expect(@bobtag.get_all_notes).to eq([@bob,@trey,@mike])
  end

end
