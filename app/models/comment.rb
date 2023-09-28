class Comment < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: :user_id
  belongs_to :post, class_name: 'Post', foreign_key: :post_id

  attribute :text, :text

  def update_comments_counter
    post.update(commentsCounter, post.comments.count)
  end
end
