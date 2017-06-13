class CreateGoogleIdentities < ActiveRecord::Migration[5.1]
  def change
    create_table :google_identities, id: :uuid do |t|
      t.string :email, null: false, index: { unique: true }
      t.text :image
      t.string :provider, default: "google", null: false
      t.string :token, null: false, index: { unique: true }
      t.datetime :token_expires_at
      t.string :uid, null: false, index: { unique: true }
      t.uuid :user_id, foreign_key: true, null: false, index: { unique: true }
      t.timestamps
    end
  end
end
