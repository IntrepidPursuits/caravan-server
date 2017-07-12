class CreateTwitterIdentities < ActiveRecord::Migration[5.1]
  def change
    create_table :twitter_identities, id: :uuid do |t|
      t.text :image
      t.string :screen_name
      t.string :provider, default: "twitter", null: false
      t.string :twitter_id, null: false, index: { unique: true }
      t.uuid :user_id, foreign_key: true, null: false, index: { unique: true }
      t.timestamps
    end
  end
end
