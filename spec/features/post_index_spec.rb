require 'rails_helper'

RSpec.feature 'Post Index Page' do
  before(:each) do
    @user1 = User.create(name: 'user1', bio: 'Teacher from Uganda', photo: 'user1_profile_image.jpg', postsCounter: 2)
    @user2 = User.create(name: 'user2')
    @post1 = Post.create(author_id: @user1.id, title: 'Hello')
    @post2 = Post.create(author_id: @user1.id, title: 'World', text: 'Hi men', commentsCounter: 1, likesCounter: 2)
    @comment = Comment.create(post_id: @post2.id, user_id: @user2.id, text: 'a comment')
  end

  scenario 'I can see the users profile picture' do
    visit user_posts_path(@user1)
    expect(page).to have_css('img[src*="user1_profile_image.jpg"]')
  end

  scenario 'I can see the users username' do
    visit user_posts_path(@user1)
    expect(page).to have_content(@user1.name)
  end

  scenario 'I can see the number of posts the user has written' do
    visit user_posts_path(@user1)
    expect(page).to have_content(@user1.postsCounter)
  end

  scenario 'I can see a posts title' do
    visit user_posts_path(@user1)
    expect(page).to have_content(@post2.title)
  end

  scenario 'I can see some of the posts body' do
    visit user_posts_path(@user1)
    expect(page).to have_content(@post2.text)
  end

  scenario 'I can see the first comments on a post' do
    visit user_posts_path(@user1)
    expect(page).to have_content(@comment.text)
  end

  scenario 'I can see how many comments a post has' do
    visit user_posts_path(@user1)
    expect(page).to have_content(@post2.commentsCounter)
  end

  scenario 'I can see how many likes a post has' do
    visit user_posts_path(@user1)
    expect(page).to have_content(@post2.likesCounter)
  end

  scenario 'I can see a section for pagination if there are more posts than fit on the view' do
    visit user_path(@user1)
    expect(page).to have_link(@post2.title)
    click_link @post2.title
    expect(current_path).to eq(user_post_path(@user1, @post2))
  end

  scenario "When I click on a post, it redirects me to that post's show page" do
    visit user_posts_path(@user1)
    expect(page).to have_content('Hi men', wait: 5)
  end
end
