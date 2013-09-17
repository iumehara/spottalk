class StaticPagesController < ApplicationController
  def home
  	@posts = Post.all
  	@post = Post.new
  end

  def about
  end
end
