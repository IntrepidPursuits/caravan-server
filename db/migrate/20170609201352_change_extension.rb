class ChangeExtension < ActiveRecord::Migration[5.1]
  def change
    disable_extension "uuid-ossp"
    enable_extension "pgcrypto"
  end
end
