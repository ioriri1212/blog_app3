class Post < ApplicationRecord
  #after_destroy rank_destroy_action
  belongs_to :user
  after_destroy :rank_destroy_action
  def rank_destroy_action
  REDIS.zrem "posts/daily/#{Date.today.to_s}", "#{id}" # 2)
  end
end
