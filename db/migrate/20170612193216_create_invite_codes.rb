class CreateInviteCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :invite_codes, id: :uuid do |t|
      t.string :code, null: false, index: { unique: true }
    end
  end
end
