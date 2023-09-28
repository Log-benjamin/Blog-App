class Post < ApplicationRecord
  belongs_to :author, class_name: 'User'
  has_many :comments
  has_many :likes

  attribute :title, :string
  attribute :text, :text
  attribute :commentsCounter, :integer, default: 0
  attribute :likesCounter, :integer, default: 0

  def update_posts_counter
    author.update(postsCounter: author.posts.count)
  end

  def most_recent_comments
    comments.order(created_at: :desc).limit(5)
  end
end
