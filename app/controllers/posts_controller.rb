class PostsController < ApplicationController
 before_action :correct_user,   only: [:destroy, :edit, :update]

def index
  @posts = Post.all.order(created_at: 'desc')

  ids = REDIS.zrevrange "posts/daily/#{Date.today.to_s}", 0, 5
  @ranks = ids.map{ |id| Post.find(id) }

end

def show
    @post = Post.find(params[:id])
    #@pv = REDIS.incr "posts/#{@post.id}"
    #@pv_num = REDIS.zincrby "posts/", 1, "#{@post.id}"
    #@ids = REDIS.zrevrange "posts/", 0, 2
    #@ranking_articles = @ids.map{ |id| Post.find(id) }

    REDIS.zincrby "posts/daily/#{Date.today.to_s}", 1, "#{@post.id}"
    ids = REDIS.zrevrange "posts/daily/#{Date.today.to_s}", 0, 5
    @ranks = ids.map{ |id| Post.find(id) }
end

def create
  @post = Post.new(post_params)
  @post.save
  redirect_to "/"
end

def new
end

def edit
  @post = Post.find(params[:id])
end

def update
  @post = Post.find(params[:id])
  if @post.update(post_params)
    redirect_to posts_path
  else
    render "posts"
  end
end

def destroy
  @post = Post.find(params[:id])
  @post.destroy
  redirect_to posts_path
end


  private

    def post_params
      params.require(:post).permit(:title, :body, :user_id)
    end

    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end

end
