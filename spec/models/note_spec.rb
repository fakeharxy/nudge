require 'rails_helper'

RSpec.describe Note, type: :model do
  before(:each) do
    @bob = Note.create!(body: "bob")
  end

  subject {
    described_class.new()
  }

  it 'is valid' do
    expect(subject).to be_valid
  end

  it 'initialises with certain defaults' do
    expect(@bob.last_seen).to eq(Date.today)
    expect(@bob.seentoday).to eq(false)
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

  it 'can overwrite the importance of a secondary tag when a primary is made' do
    @bob.add_secondary_tags = "hello, this, tags"
    @bob.add_primary_tag = "hello"
    expect(@bob.primary_tag.importance).to eq(5)
  end


  it 'deletes a tag when the note is deleted' do
    @bob.add_secondary_tags = "hello"
    @bob.destroy_with_tags
    expect(Tag.all).to eq([])
  end

  it 'can determine order from importance' do
    @bob.add_primary_tag = "hello"
    @bob.primary_tag.importance = 7
    @bob.set_last_seen = 2.days.ago
    expect(@bob.urgency).to eq(21)
  end

  it 'will be the importance value if the date seen is today' do
    @bob.add_primary_tag = "hello"
    @bob.primary_tag.importance = 4
    @bob.set_last_seen = Date.today
    expect(@bob.urgency).to eq(4)
  end

  it 'will be able to provide the most urgent note' do
    @bob.add_primary_tag = "hello"
    @bob.primary_tag.importance = 7
    @bob.set_last_seen = 2.days.ago
    @mike = Note.create!(body: "Mike")
    @mike.add_primary_tag = "donkey"
    @mike.primary_tag.importance = 6
    @mike.set_last_seen = 2.days.ago
    expect(Note.get_most_urgent).to eq(@bob)
  end

  it 'will be able to find the most urgent note part 2' do
    @bob.add_primary_tag = "hello"
    @bob.primary_tag.importance = 3
    @bob.set_last_seen = 2.days.ago
    @trey = Note.create!(body: "Trey")
    @trey.add_primary_tag = "donkey"
    @trey.primary_tag.importance = 3
    @trey.set_last_seen = 3.days.ago
    expect(Note.get_most_urgent).to eq(@trey)
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
