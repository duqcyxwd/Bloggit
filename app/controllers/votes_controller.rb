class VotesController < ApplicationController
  def up_vote
    # Just like other controllers, grab the parent objects
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:post_id])

    # Look for an existing vote by this person so we don't create multiple
    @vote = @post.votes.where(user_id: current_user.id).first

    if @vote # if it exists, update it
      @vote.update_attribute(:value, 1)
    else # create it
      @vote = current_user.votes.create(value: 1, post: @post)
    end
    redirect_to :back
  end
end