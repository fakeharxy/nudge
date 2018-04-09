require 'rails_helper'

RSpec.describe Tag, type: :model do
  before(:all) do
    @user = User.new(email: "bob@email.com")
    @user.save(validate: false)
  end

  before(:each) do
    @tag = Tag.create!(name: "tag", user_id: @user.id)
    @second = Second.create!(name: "second", tag_id: @tag.id, user_id: @user.id)
    @bob = Note.create!(body: "bob", tag_id: @tag.id, second_id: @second.id, user_id: @user.id)
    @bob.add_tag("hello", @user.id)
    @bobtag = Tag.find_by(name: "hello")
  end

  it 'has default importance of 5' do
    expect(@bob.tag.importance).to eq(5)
  end

  it 'does not overwrite existing importance' do
    @mike = Note.create!(body: "mike", tag_id: @tag.id, second_id: @second.id, user_id: @user.id)
    @bob.tag.set_importance = 7
    @mike.add_tag("hello", @user.id)
    expect(@mike.tag.importance).to eq(7)
  end

  it 'can get all notes it belongs to' do
    expect(@bobtag.get_all_notes).to eq([@bob])
  end

  it 'can get all primary notes' do
    @mike = Note.create!(body: "mike", tag_id: @tag.id, second_id: @second.id, user_id: @user.id)
    @mike.add_second("snacks", @tag.id, @user.id)
    expect(Tag.get_all_tags(@user.id)).to eq([@bobtag])
  end

  it 'can return number of notes' do
    @mike = Note.create!(body: "mike", tag_id: @tag.id, second_id: @second.id, user_id: @user.id)
    @mike.add_second("hello", @tag.id, @user.id)
    @tim = Note.create!(body: "tim", tag_id: @tag.id, second_id: @second.id, user_id: @user.id)
    @tim.add_tag("hello", @user.id)
    @tim.add_second("herro", @tag.id, @user.id)
    expect(Tag.find_by(name:"hello").note_count).to eq(2)
  end

  it 'can get multiple notes(with secondary tags)' do
    @trey = Note.create!(body: "trey", tag_id: @tag.id, second_id: @second.id, user_id: @user.id)
    @trey.add_tag("hello", @user.id)
    @mike = Note.create!(body: "mike", tag_id: @tag.id, second_id: @second.id, user_id: @user.id)
    @mike.add_second("hello", @tag.id, @user.id)
    expect(@bobtag.get_all_notes).to eq([@bob,@trey])
  end
end
