class Notification::Relationship < Notification
  validates :user, presence: true

  delegate :follower_name, to: :notifiable

  DEFAULT_META_DATA = { other_followers_count: 0 }.freeze

  def message
    if other_followers_count.positive?
      "#{follower_name}さん他#{other_followers_count}名にフォローされました"
    else
      "#{follower_name}さんにフォローされました"
    end
  end

  def increment_other_followers_count
    parsed_meta = JSON.parse(self.meta)
    parsed_meta['other_followers_count'] += 1
    self.meta = parsed_meta.to_json
    save
  end

  def other_followers_count
    JSON.parse(self.meta)['other_followers_count']
  end

  class << self
    def send_new_relationship_notification(relationship)
      followed = relationship.followed

      recent_notification = followed.notifications.relationships.find_by(updated_at: 5.minutes.ago..)
      if recent_notification
        return recent_notification.increment_other_followers_count
      end

      followed.notifications.create(
        notifiable: relationship,
        notifiable_type: relationship.class,
        type: self,
        meta: DEFAULT_META_DATA.to_json
      )
    end
  end
end
