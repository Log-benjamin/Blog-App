require 'rails_helper'

def custom_photo(custom_text = 'user-pic')
  "https://makeplaceholder.com?size=100&bg=f4bcae&text=#{custom_text}&tcolor=ffffff&as=png"
end

def custom_bio(user_name = 'user_name')
  rows_bio = [
    "English: Hello, my name is #{user_name}, and this is my bio.",
    "Spanish: Hola, mi nombre es #{user_name} y este es mi bio.",
    "French: Bonjour, je m'appelle #{user_name} et voici ma bio.",
    "German: Hallo, mein Name ist #{user_name} und das ist meine Bio.",
    "Portuguese: Olá, meu nome é #{user_name} e esta é a minha bio."
  ]

  rows_bio.join('\n')
end

RSpec.describe 'Posts Show Page', type: :system do
  let!(:user) { User.create(name: 'Sahalu', photo: 'https://makeplaceholder.com?size=100&bg=f4bcae&text=photo&tcolor=ffffff&as=png') }
  let!(:post1) { user.posts.create(title: 'Sample Post Title', text: 'Sample Post Content') }

  before(:each) do
    %w[1 2 3 4 5 6 7 8].each do |u|
      user = User.create(name: "User#{u}", photo: "https://makeplaceholder.com?size=100&bg=f4bcae&text=user#{u}&tcolor=ffffff&as=png")
      Comment.create(post: post1, user:, text: "Sample Post Comment from #{user.name}")
      Like.create(post: post1, user:)
    end
    @current_user = User.first
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

    it 'shows a [Like] button' do
      expect(page).to have_button('Like')
    end
  end

  describe 'displays comments for the posts' do
    before { visit user_post_path(user, post1) }

    it 'shows all the comments' do
      selector = 'div.comments ul'
      within(selector) { expect(page.all('li').count).to eq(post1.most_recent_comments.count) }
    end

    it 'shows the username of each commentor' do
      selector = 'div.comments ul'
      post1.most_recent_comments.each do |comment|
        within(selector) { expect(page).to have_css('li', text: /#{comment.user.name}:/) }
      end
    end

    it 'shows the comment each commentor left' do
      selector = 'div.comments ul'
      post1.most_recent_comments.each do |comment|
        within(selector) { expect(page).to have_css('li', text: /: #{comment.text}/) }
      end
    end

    it 'shows a [Add Comment] button' do
      expect(page).to have_link('Add Comment')
    end
  end

  describe 'links attached to the page' do
    before { visit user_post_path(user, post1) }

    it 'when clicking on [Like] button, increases the Likes of the post' do
      click_on 'Like'
      expect(page).to have_content("Likes: #{post1.likesCounter_was + 1}")
    end

    it 'redirects to add comment when clicking on [Add Comment] button' do
      click_link 'Add Comment'
      expect(page).to have_current_path(new_user_post_comment_path(post1.author, post1))
    end
  end
end
