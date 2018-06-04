class ArticleController < ApplicationController

  def home
  @posts = Post.all.order(created_at: 'desc')
  
  end

end
