class CreateWebhookSubscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :webhook_subscriptions do |t|
      t.string :url
      t.string :event
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
