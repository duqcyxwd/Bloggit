class CommentsController < ApplicationController
	def create
		# @comment = Comment.new()
		@topic = Topic.find(params[:topic_id])
		@post = Post.find(params[:post_id])
		@comments = @post.comments

		# @comment = current_user.comments.build(params[:comment])
		# @comment.post = @post

		@comment = Comment.new(
			user: current_user,
			post: @post,
			body: params[:comment][:body])

		authorize! :create, @topic, message: "You need to be an admin to do that."
		if @comment.save
			flash[:notice] = "comment was saved successfully."
			redirect_to [@topic, @post]
		else
			flash[:error] = "Error creating comment. Please try again."
			render 'posts/show'
		end
	end
end
