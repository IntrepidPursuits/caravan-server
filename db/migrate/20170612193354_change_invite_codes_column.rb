class ChangeInviteCodesColumn < ActiveRecord::Migration[5.1]
  def up
    remove_column :trips, :invite_code
    add_column :trips, :invite_code_id, :uuid, null: false, foreign_key: true, index: { unique: true }
  end

  def down
    add_column :trips, :invite_code, :string, null: false
    add_index :trips, :invite_code, unique: true
    remove_column :trips, :invite_code_id
  end
end
