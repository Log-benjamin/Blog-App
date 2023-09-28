require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { User.create(name: 'Benjamin') }
  let(:post) { Post.create(title: 'Is Ruby The Best?', text: 'I Love Rails Framework', author_id: user.id) }

  describe 'Validate if a user and a post exist before giving a like' do
    it 'should like existing post' do
      like = Like.new(user:)
      expect(like).not_to be_valid
      expect(like.errors[:post]).to include('must exist')
    end

    it 'should not like a post without a user' do
      like = Like.new
      expect(like).not_to be_valid
      expect(like.errors[:user]).to include('must exist')
    end
  end

  describe 'Method test for Like Model updates likes counter' do
    it 'should update likes_counter after create' do
      expect do
        like = Like.create(user:, post:)
        like.save
      end.to change { post.reload.likesCounter }.by(1)
    end
  end
end
