class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  has_many :notes
  has_many :tags
  has_many :seconds
  after_create :fill_db

  def tags_in_order_of_most_used
    tags.all.sort_by{|i| - i.note_count}
  end

  def fill_db
    @tag = Tag.create!(name: "note|back", user_id: self.id)
    @second = Second.create!(name: "welcome", tag_id: @tag.id, user_id: self.id)
    Note.create!(body: "Thank you so much for signing up to note|back. I suppose you’re wondering what you’ve got yourself in for? Well, don’t worry, I’ve added some notes in here for you to have a look at.\r\n

But to answer the question: what is it? It’s a lot of things to a lot of different people. It’s a way to take notes without ever having to worry again whether you’ll ever see it again. It’s not buried in a notebook, it’s not in some folder on your computer, it’s not even at the bottom of a huge digital stack of Evernotes.\r\n

You’ll be prompted, every time you log on to note|back, to take some time to review some (just 5!) of your notes. In the background, a (mildly) complex system is spacing these notes so you see newer notes more often - to solidify their place in your brain.\r\n

That’s enough for now. What do people actually use it for? Click the blue button with the eye on it above to see some examples… that will set this note as ‘Seen’ for today - you’ll see it again another time.", user_id: self.id, tag_id: @tag.id, second_id: @second.id, importance:13)

    @tag2 = Tag.create!(name: "quote", user_id: self.id)
    @second2 = Second.create!(name: "flannery o'connor", tag_id: @tag2.id, user_id: self.id)
    Note.create!(body: "I write because I don't know what I think until I read what I say. - Flanner O'Connor", user_id: self.id, tag_id: @tag2.id, second_id: @second2.id, importance:13)

    @tag3 = Tag.create!(name: "recipes", user_id: self.id)
    @second3 = Second.create!(name: "pancakes", tag_id: @tag3.id, user_id: self.id)
    Note.create!(body: "Put the flour, eggs, milk, 1 tbsp oil and a pinch of salt into a bowl or large jug, then whisk to a smooth batter.\r\n
Set a medium frying pan or crêpe pan over a medium heat and carefully wipe it with some oiled kitchen paper.\r\n
Serve with lemon wedges and sugar, or your favourite filling.", user_id: self.id, tag_id: @tag3.id, second_id: @second3.id, importance:13)

    @second4 = Second.create!(name: "making your own note|backs", tag_id: @tag.id, user_id: self.id)

    Note.create!(body: "So you’ve seen a few possible note|backs. They’re notes you’ve got back - gettit? Now you are probably ready to create your own.\r\n

A note can be anything - anything you don’t want to forget. Sometimes I see this as a bucket - a physical or a GTD bucket. Just pour ideas and thoughts into it. Novel idea? Lifehack you’ve seen on the internet? Reminder to check out a film?\r\n

Anything you don’t want clogging up your brain, pop it into note|back. We’ll keep it for you.\r\n

One great use is when you are trying to learn something. I tend to add anything I want to remember - like how to migrate a database, or make a cocktail, or build a wall… I add it to note|back with the #learning tag.\r\n

The #learning tag you say? What the deuce?", user_id: self.id, tag_id: @tag.id, second_id: @second4.id, importance:13)
  end
end
