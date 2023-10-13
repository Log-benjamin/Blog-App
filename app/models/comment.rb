class Comment < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: :user_id
  belongs_to :user
  belongs_to :post

  after_save :increase_comment_counter
  after_destroy :decrease_comment_counter

  private

  def increase_comment_counter
    post.increment!(:commentsCounter)
  end

  def decrease_comment_counter
    post.decrement!(:commentsCounter)
  end
end
