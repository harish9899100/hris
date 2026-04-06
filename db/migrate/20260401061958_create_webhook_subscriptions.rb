class CreateWebhookSubscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :webhook_subscriptions do |t|
      t.string :url
      t.string :event

      t.timestamps
    end
  end
end
