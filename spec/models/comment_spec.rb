require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { User.create(name: 'Alice') }
  let(:post) { user.posts.create(title: 'Sample Post') }

  describe 'validations' do
    it 'should be valid with valid attributes' do
      comment = post.comments.build(author: user)
      expect(comment).to be_valid
    end

    it 'should not be valid without an author' do
      comment = post.comments.build(author: nil)
      expect(comment).to_not be_valid
    end
  end

  describe 'Method test for Comment Model' do
    it 'should update comments counter after create' do
      user = User.create(name: 'Harry')
      post = Post.create(title: 'Title', author: user)
      post.comments.create(author: user)
      expect(post.commentsCounter).to eq(1)
    end
  end
end
