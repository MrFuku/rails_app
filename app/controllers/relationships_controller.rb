class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])
    # フォロー＆通知の処理をサービスクラスに委譲しても良さそう
    current_user.follow(@user)
    relationship = Relationship.find_by(followed: @user, follower: current_user)
    Notification::Relationship.send_new_relationship_notification(relationship)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
