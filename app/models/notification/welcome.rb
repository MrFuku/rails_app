class Notification::Welcome < Notification
  validates :user, presence: true, uniqueness: true

  def message
    "初回ログインありがとうございます。"
  end

  class << self
    def send_welcome_notification(user)
      user.notifications.create(type: self)
    end
  end
end
