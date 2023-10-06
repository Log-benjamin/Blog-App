require 'rails_helper'

RSpec.describe 'Posts Index Page', type: :system do
  let!(:user) { User.create(name: 'Sahalu', photo: 'https://makeplaceholder.com?size=100&bg=f4bcae&text=photo&tcolor=ffffff&as=png') }
  let!(:post1) { user.posts.create(title: 'Sample Post Title', text: 'Sample Post Content') }
  let!(:post2) { user.posts.create(title: 'Sample Post Title', text: 'Sample Post Content') }

  before(:each) do
    Comment.create(post: post1, user:, text: 'Sample Post Comment')
    Comment.create(post: post2, user:, text: 'Sample Post Comment')
    Like.create(post: post1, user:)
    Like.create(post: post2, user:)
  end

  describe 'displays user information:' do
    before { visit user_posts_path(user) }

    it 'show profile picture of user' do
      expect(page).to have_css("img[src='#{user.photo}']")
    end

    it 'show the name of user' do
      expect(page).to have_css('h1', text: user.name)
    end

    it 'show number of posts of user' do
      expect(page).to have_content(user.reload.postsCounter)
    end
  end

  describe 'displays all user posts' do
    before { visit user_posts_path(user) }

    it 'shows the post title' do
      [post1, post2].each do |post|
        expect(page).to have_content(post.title)
      end
    end

    it 'shows the text of the post' do
      [post1, post2].each do |post|
        expect(page).to have_content(post.text)
      end
    end

    it 'shows how many comments the post has' do
      [post1, post2].each do |post|
        expect(page).to have_content("Comments: #{post.commentsCounter}")
      end
    end

    it 'shows how many likes the post has' do
      [post1, post2].each do |post|
        expect(page).to have_content("Likes: #{post.likesCounter}")
      end
    end

    it 'shows the first comment on a post' do
      expect(page).to have_content(post1.reload.comments.first.text)
      expect(page).to have_content(post2.reload.comments.first.text)
    end

    it 'there is a pagination button' do
      expect(page).to have_button('Pagination')
    end
  end

  describe 'links attached to the page' do
    before do
      visit user_posts_path(user)
      @current_user = User.first
    end

    it 'redirects to the post show page when clicking on a post' do
      find("a[href='#{user_post_path(user, post1)}']").click
      expect(page).to have_current_path(user_post_path(user, post1))
    end

    it 'redirects to create new post when clicking on create_a_post button' do
      click_link 'Add Post'
      expect(page).to have_current_path(new_user_post_path(@current_user))
    end
  end
end
