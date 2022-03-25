class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :notifiable, polymorphic: true, index: true
      t.references :user, null: false, foreign_key: true
      t.string :type, index: true
      t.boolean :checked
      t.text :meta

      t.timestamps
    end
  end
end
