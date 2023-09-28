require 'rails_helper'

RSpec.describe Post, type: :model do
  subject { Post.new(title: 'General Relativity', author: User.create(name: 'Albert E')) }

  before { subject.save }

  describe 'Validation test for Post Model title' do
    it 'Title must be present' do
      subject.title = 'Algorithm'
      expect(subject).to be_valid
    end

    it 'Title must not be blank' do
      subject.title = nil
      expect(subject).to_not be_valid
    end

    it 'Title must be 250 characters at max' do
      subject.title = 'z' * 251
      expect(subject).to_not be_valid

      subject.title = 'z' * 249
      expect(subject).to be_valid
    end
  end

  describe 'Validation test for Post Model comments counter' do
    it 'Comments counter must be an integer' do
      subject.commentsCounter = 'five'
      expect(subject).to_not be_valid
    end

    it 'Comments counter must be greater than or equal to 0' do
      subject.commentsCounter = -1
      expect(subject).to_not be_valid
    end

    it 'Comments counter must be greater than or equal to 0' do
      subject.commentsCounter = 0
      expect(subject).to be_valid
    end

    it 'Comments counter must be greater than or equal to 0' do
      subject.commentsCounter = 12
      expect(subject).to be_valid
    end
  end

  describe 'Validation test for Post Model likes counter' do
    it 'Comments counter must be an integer' do
      subject.likesCounter = 'Good'
      expect(subject).to_not be_valid
    end

    it 'Comments counter must be greater than or equal to 0' do
      subject.likesCounter = -8
      expect(subject).to_not be_valid
    end

    it 'Comments counter must be greater than or equal to 0' do
      subject.likesCounter = 0
      expect(subject).to be_valid
    end

    it 'Comments counter must be greater than or equal to 0' do
      subject.likesCounter = 42
      expect(subject).to be_valid
    end
  end

  describe 'Method test for Post Model' do
    it 'should update posts_counter after create' do
      user = User.create(name: 'Harry')
      Post.create(title: 'Title', author: user)
      expect(user.postsCounter).to eq(1)
    end
  end
end
