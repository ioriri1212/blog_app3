class ApplicationController < ActionController::Base

  def set_ranking_data
    @post = Post.find(params[:id])
    #@pv = REDIS.incr "posts/#{@post.id}"
    #@pv_num = REDIS.zincrby "posts/", 1, "#{@post.id}"
    #@ids = REDIS.zrevrange "posts/", 0, 2
    #@ranking_articles = @ids.map{ |id| Post.find(id) }

    REDIS.zincrby "posts/daily/#{Date.today.to_s}", 1, "#{@post.id}"
    ids = REDIS.zrevrange "posts/daily/#{Date.today.to_s}", 0, 5
    @ranks = ids.map{ |id| Post.find(id) }
  end
end
