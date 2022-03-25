class Notification::Relationship < Notification
  validates :user, presence: true

  delegate :follower_name, to: :notifiable

  def message
    "#{follower_name}さんにフォローされました"
  end

  class << self
    def send_new_relationship_notification(relationship)
      followed = relationship.followed

      followed.notifications.create(
        notifiable: relationship,
        notifiable_type: relationship.class,
        type: self
      )
    end
  end
end
