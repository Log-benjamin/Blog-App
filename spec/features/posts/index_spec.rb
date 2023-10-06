require 'rails_helper'

RSpec.describe 'Posts Index Page', type: :system do
  let!(:user) { User.create(name: 'Luigi', photo: 'https://makeplaceholder.com?size=100&bg=f4bcae&text=photo&tcolor=ffffff&as=png') }
  let!(:post1) { user.posts.create(title: 'Sample Post Title', text: 'Sample Post Content') }
  let!(:post2) { user.posts.create(title: 'Sample Post Title', text: 'Sample Post Content') }

  before(:each) do
    Comment.create(post: post1, user:, text: 'Sample Post Comment')
    Comment.create(post: post2, user:, text: 'Sample Post Comment')
    Like.create(post: post1, user:)
    Like.create(post: post2, user:)
  end

  describe 'displays the post information:' do
    before { visit user_post_path(user, post1) }

    it "shows the post's title" do
      expect(page).to have_css('h3', text: post1.title)
    end

    it 'shows who wrote the post' do
      expect(page).to have_css('span', text: post1.author.name)
    end

    it 'shows how many comments it has' do
      expect(page).to have_content("Comments: #{post1.commentsCounter}")
    end

    it 'shows how many likes it has' do
      expect(page).to have_content("Likes: #{post1.likesCounter}")
    end

    it 'shows the post body' do
      expect(page).to have_css('p', text: post1.text)
    end
  end

  describe 'displays all the comments for the posts' do
    # I can see the username of each commentor.
    # I can see the comment each commentor left.
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
      expect(page).to have_current_path(new_user_post_path(user))
    end
  end
end
