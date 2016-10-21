class CreateNotificationMails < ActiveRecord::Migration[5.0]
  def change
    create_table :notification_mails do |t|
      t.string :user

      t.timestamps
    end
  end
end
