require 'rails_helper'

RSpec.describe Tag, type: :model do
  before(:all) do
    @user = User.new(email: "bob@email.com")
    @user.save(validate: false)
  end

  before(:each) do
    @bob = Note.create!(body: "bob", user_id: @user.id)
    @bob.add_primary_tag("hello", @user.id)
    @bobtag = Tag.find_by(name: "hello")
  end

  it 'has default importance of 5' do
    expect(@bob.primary_tag.importance).to eq(5)
  end

  it 'does not overwrite existing importance' do
    @mike = Note.create!(body: "mike", user_id: @user.id)
    @bob.primary_tag.set_importance = 7
    @mike.add_primary_tag("hello", @user.id)
    expect(@mike.primary_tag.importance).to eq(7)
  end

  it 'can get all notes it belongs to' do
    expect(@bobtag.get_all_notes).to eq([@bob])
  end

  it 'can return number of notes' do
    @mike = Note.create!(body: "mike", user_id: @user.id)
    @mike.add_secondary_tags("hello", @user.id)
    @tim = Note.create!(body: "tim", user_id: @user.id)
    @tim.add_primary_tag("hello", @user.id)
    @tim.add_secondary_tags("herro,my,friend", @user.id)
    expect(Tag.find_by(name:"hello").note_count).to eq(3)
  end

  it 'can get multiple notes(with secondary tags)' do
    @trey = Note.create!(body: "trey", user_id: @user.id)
    @trey.add_primary_tag("hello", @user.id)
    @mike = Note.create!(body: "mike", user_id: @user.id)
    @mike.add_secondary_tags("hello", @user.id)
    expect(@bobtag.get_all_notes).to eq([@bob,@trey,@mike])
  end

  it 'can get multiple notes in order' do
    @trey = Note.create!(body: "trey", user_id: @user.id)
    @trey.add_primary_tag("hello", @user.id)
    @treytag = Tag.find_by(name:"hello")
    @mike = Note.create!(body: "mike", user_id: @user.id)
    @mike.add_secondary_tags("monkey", @user.id)
    @miketag = Tag.find_by(name:"monkey")
    expect(Tag.in_order_of_most_used(@user.id)).to eq ([@treytag, @miketag])
  end

end
