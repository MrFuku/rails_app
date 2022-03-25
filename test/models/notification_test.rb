require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  class Notification::RelationshipTest < self
    def setup
      @notification_relationship = notifications(:one)
    end
  
    test "should be valid" do
      assert @notification_relationship.valid?
    end

    test "#message: return message when a user is followed" do
      follower_name = @notification_relationship.notifiable.follower_name
      assert_equal @notification_relationship.message, "#{follower_name}さんにフォローされました"
    end

    test "#message: message includes other followers count if exists other followers" do
      other_followers_count = 2
      @notification_relationship.meta = "{\"other_followers_count\":#{other_followers_count}}"

      follower_name = @notification_relationship.notifiable.follower_name
      assert_equal @notification_relationship.message, "#{follower_name}さん他#{other_followers_count}名にフォローされました"
    end

    test ".send_new_relationship_notification: add a notification" do
      relationship = relationships(:two)
      notification = nil
      assert_difference ['Notification::Relationship.count'], 1 do
        notification = Notification::Relationship.send_new_relationship_notification(relationship)
      end
      assert_equal notification.notifiable, relationship
      assert_equal notification.user, relationship.followed
    end

    test ".send_new_relationship_notification: do not add If last notification is within 5 minutes" do
      notified_user = @notification_relationship.notifiable.followed
      other_relationhip = Relationship.create(follower: users(:user_1), followed: notified_user)
      notification = nil
      assert_difference ->{ Notification::Relationship.count } => 0, ->{ @notification_relationship.reload.other_followers_count } => 1 do
        Notification::Relationship.send_new_relationship_notification(other_relationhip)
      end

      @notification_relationship.update(updated_at: 6.minutes.ago)
      assert_difference ->{ Notification::Relationship.count } => 1 do
        Notification::Relationship.send_new_relationship_notification(other_relationhip)
      end
    end
  end
end
