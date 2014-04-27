class AddUserbinTo<%= table_name.camelize %> < ActiveRecord::Migration
  def up
    change_table :<%= table_name %> do |t|
      t.string   :userbin_id
    end

    add_index :<%= table_name %>, :userbin_id, :unique => true
  end

  def down
    remove_column :<%= table_name %>, :userbin_id
  end
end
