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

		authorize! :create, @comment, message: "You need be signed in to do that."
		if @comment.save
			flash[:notice] = "comment was saved successfully."
			redirect_to [@topic, @post]
		else
			flash[:error] = "Error creating comment. Please try again."
			render 'posts/show'
		end
	end

	def destroy
		@topic = Topic.find(params[:topic_id])
		@post = @topic.posts.find(params[:post_id])

		@comment = @post.comments.find(params[:id])

		authorize! :destroy, @comment, message: "You need to own the comment to delete it."
		if @comment.destroy
			flash[:notice] = "Comment was removed."
			redirect_to [@topic, @post]
		else
			flash[:error] = "Comment couldn't be deleted. Try again."
			redirect_to [@topic, @post]
		end
  end
end
