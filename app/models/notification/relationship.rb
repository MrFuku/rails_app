class Notification::Relationship < Notification
  validates :user, presence: true

  delegate :follower_name, to: :notifiable

  def message
    "#{follower_name}さんにフォローされました"
  end
end
