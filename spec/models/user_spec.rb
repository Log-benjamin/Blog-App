require 'rails_helper'

RSpec.describe User, type: :model do
  subject { User.new(name: 'Lilly', photo: 'https://unsplash.com/photos/F_-0BxGuVvo', bio: 'Teacher from Poland.', postsCounter: 5) }

  before { subject.save }

  describe 'Validation test for User Model name' do
    it 'Name must be present' do
      subject.name = 'Binyam'
      expect(subject).to be_valid
    end

    it 'Name must not be blank' do
      subject.name = nil
      expect(subject).to_not be_valid
    end
  end

  describe 'Validation test for User Model postsCounter' do
    it 'post counter must be an integer value' do
      subject.postsCounter = 'Hi'
      expect(subject).to_not be_valid
    end

    it 'post counter must be greater than or equal to 0' do
      subject.postsCounter = -3
      expect(subject).to_not be_valid

      subject.postsCounter = 0
      expect(subject).to be_valid

      subject.postsCounter = 4
      expect(subject).to be_valid
    end
  end

  describe 'Method test for User Model most recent posts' do
    it 'return the three most recent posts' do
      subject = User.create(name: 'benji')

      Post.create(title: 'title one', text: 'text one', author: subject, created_at: 5.days.ago)
      Post.create(title: 'title two', text: 'text two', author: subject, created_at: 4.days.ago)
      post3 = Post.create(title: 'title three', text: 'text three', author: subject, created_at: 3.days.ago)
      post4 = Post.create(title: 'title four', text: 'text four', author: subject, created_at: 2.days.ago)
      post5 = Post.create(title: 'title five', text: 'text five', author: subject, created_at: 1.days.ago)

      expect(subject.most_recent_posts).to eq([post5, post4, post3])
    end
  end
end
