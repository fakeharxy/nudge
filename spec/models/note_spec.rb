require 'rails_helper'

RSpec.describe Note, type: :model do
  before(:all) do
    @user = User.new
    @user.save(validate: false)
  end

  before(:each) do
    @bob = Note.create!(body: "bob", user_id: @user.id)
  end

  it 'initialises with certain defaults' do
    expect(@bob.last_seen).to eq(Date.today)
    expect(@bob.seentoday).to eq(false)
  end

  it 'accepts a primary tag' do
    @bob.add_primary_tag("hello", user_id: @user.id)
    expect(@bob.get_primary_tag_name).to eq("hello")
  end

  it 'accepts multiple secondary tags' do
    @bob.add_secondary_tags("hello, this, tags", @user.id)
    expect(@bob.get_all_tag_names).to eq(["hello", "this", "tags"])
  end

  it 'can return both primary and secondary tags' do
    @bob.add_secondary_tags("hello, this, tags", @user.id)
    @bob.add_primary_tag("mike", @user.id)
    expect(@bob.get_all_tag_names).to eq(["hello", "this", "tags", "mike"])
  end

  it 'can overwrite the importance of a secondary tag when a primary is made' do
    @bob.add_secondary_tags("hello, this, tags", @user.id)
    @bob.add_primary_tag("hello", @user.id)
    expect(@bob.primary_tag.importance).to eq(3)
  end

  it 'deletes a tag when the note is deleted' do
    @bob.add_secondary_tags("hello, this, tags", @user.id)
    @bob.destroy_with_tags
    expect(Tag.all).to eq([])
  end

  it 'can determine order from importance' do
    @bob.add_primary_tag("mike", @user.id)
    @bob.primary_tag.importance = 7
    @bob.set_last_seen = 2.days.ago
    expect(@bob.urgency).to eq(21)
  end

  it 'will be the importance value if the date seen is today' do
    @bob.add_primary_tag("mike", @user.id)
    @bob.primary_tag.importance = 4
    @bob.set_last_seen = Date.today
    expect(@bob.urgency).to eq(4)
  end

  it 'will be able to provide the most urgent note' do
    @bob.add_primary_tag("mike", @user.id)
    @bob.primary_tag.importance = 7
    @bob.set_last_seen = 2.days.ago
    @mike = Note.create!(body: "Mike")
    @mike.add_primary_tag("donkey", @user.id)
    @mike.primary_tag.importance = 6
    @mike.set_last_seen = 2.days.ago
    expect(Note.get_most_urgent).to eq(@bob)
  end

  it 'will be able to find the most urgent note part 2' do
    @bob.add_primary_tag("hello", @user.id)
    @bob.primary_tag.importance = 3
    @bob.set_last_seen = 2.days.ago
    @trey = Note.create!(body: "Trey")
    @trey.add_primary_tag("donkey", @user.id)
    @trey.primary_tag.importance = 3
    @trey.set_last_seen = 3.days.ago
    expect(Note.get_most_urgent).to eq(@trey)
  end

  it 'does not delete a tag if connected to another note' do
    mike = Note.create!
    @bob.add_secondary_tags("hello,", @user.id)
    mike.add_secondary_tags("hello,", @user.id)
    @bob.destroy_with_tags
    expect(Tag.all).to_not eq([])
    mike.destroy_with_tags
    expect(Tag.all).to eq([])
  end

  it "can mark a note as seen & update last_seen" do
    @bob.set_last_seen = 3.days.ago
    @bob.mark_as_seen
    expect(@bob.last_seen).to eq(Date.today)
    expect(@bob.seentoday).to eq(true)
  end

  it "can tell if every note is seen" do
    @bob.mark_as_seen
    mike = Note.create!(body: "mike", user_id: @user.id)
    mike.mark_as_seen
    expect(Note.all_seen?(@user.id)).to eq(true)
  end

  it "can tell if every note is not seen" do
    @bob.mark_as_seen
    mike = Note.create!(body: "mike", user_id: @user.id)
    mike.mark_as_seen
    expect(Note.all_seen?(@user.id)).to eq(true)
  end

  it "can get the most recent note" do
    mike = Note.create!(body: "mike", user_id: @user.id, last_seen: 2.days.ago)
    expect(Note.most_recent(@user.id)).to eq(@bob)
  end

  it 'can reset seen_today' do
    @bob.mark_as_seen
    @trey = Note.create!(body: "Trey", user_id: @user.id)
    @trey.mark_as_seen
    Note.reset_seen_status(@user.id)
    expect(@bob.reload.seentoday).to eq(false)
    expect(@trey.reload.seentoday).to eq(false)
  end
end
