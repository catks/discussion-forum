class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.string :message
      t.boolean :sent, default: false
      t.references :notification_mail, foreign_key: true

      t.timestamps
    end
  end
end
