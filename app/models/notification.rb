class Notification < ApplicationRecord
  belongs_to :notifiable, polymorphic: true
  belongs_to :user

  scope :relationships, -> { where(notifiable_type: 'Relationship') }
end
