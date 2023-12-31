class Post < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: :author_id
  has_many :comments
  has_many :likes

  attribute :title, :string
  attribute :text, :text
  attribute :commentsCounter, :integer, default: 0
  attribute :likesCounter, :integer, default: 0

  after_save :increase_post_counter
  after_destroy :decrease_post_counter

  validates :title, presence: true, length: { maximum: 250 }
  validates :text, presence: true
  validates :commentsCounter, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :likesCounter, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def most_recent_comments
    comments.order(created_at: :desc).limit(5)
  end

  private

  def increase_post_counter
    author.increment!(:postsCounter)
  end

  def decrease_post_counter
    author.decrement!(:postsCounter)
  end
end
