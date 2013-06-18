class CommentsController < ApplicationController
	def create
		@comment = Comment.new()
		@post = Post.find(params[:id])
		@comments = @post.comments

		@comment = current_user.comment.build(params[:comment])
		@comment.post = @post
		# authorize! :create, @topic, message: "You need to be an admin to do that."
		if @comment.save
			flash[:notice] = "comment was saved successfully."
			redirect_to [@topic, @post]
		else
			flash[:error] = "Error creating comment. Please try again."
			render :new
		end
	end
end
