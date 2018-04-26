require 'rails_helper'

RSpec.describe Note, type: :model do
  before(:all) do
    @user = User.new
    @user.save(validate: false)
  end

  before(:each) do
    @tag = Tag.create!(name: "tag", user_id: @user.id)
    @second = Second.create!(name: "second", tag_id: @tag.id, user_id: @user.id)
    @bob = Note.create!(body: "bob", user_id: @user.id, tag_id: @tag.id, second_id: @second.id)
  end

  it 'initialises with certain defaults' do
    expect(@bob.last_seen).to eq(Date.today)
    expect(@bob.seentoday).to eq(false)
  end

  it 'accepts a tag' do
    @bob.add_tag("hello", @user.id)
    expect(@bob.get_tag_name).to eq("hello")
  end

  it 'can return both tags' do
    expect(@bob.get_all_tag_names).to eq(["tag", "second"])
  end

  it 'deletes a tag when the note is deleted' do
    @bob.add_second("hello", @tag.id, @user.id)
    @bob.destroy_with_tags
    expect(Tag.all).to eq([])
  end

  it 'can determine order from importance' do
    @bob.add_tag("mike", @user.id)
    @bob.tag.importance = 7
    @bob.set_last_seen = 2.days.ago
    expect(@bob.urgency).to eq(15)
  end

  it "can mark a note as seen & update last_seen" do
    @bob.set_last_seen = 3.days.ago
    @bob.mark_as_seen
    expect(@bob.last_seen).to eq(Date.today)
    expect(@bob.seentoday).to eq(true)
  end

end
