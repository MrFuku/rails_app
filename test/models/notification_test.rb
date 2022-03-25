require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  class Notification::RelationshipTest < self
    def setup
      @notification_relationship = notifications(:one)
    end
  
    test "should be valid" do
      assert @notification_relationship.valid?
    end

    test "return message when a user is followed" do
      relationship = @notification_relationship.notifiable
      follower_name = relationship.follower_name
      assert_equal @notification_relationship.message, "#{follower_name}さんにフォローされました"
    end
  end
end
