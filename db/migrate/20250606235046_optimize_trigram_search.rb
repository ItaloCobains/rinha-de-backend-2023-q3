class OptimizeTrigramSearch < ActiveRecord::Migration[8.0]
  def up
    execute "SELECT set_limit(0.2);"

    add_index :pessoas, :searchable,
              where: "length(searchable) <= 50",
              name: "index_pessoas_searchable_short"

    execute "ANALYZE pessoas;"
  end

  def down
    execute "SELECT set_limit(0.3);"

    remove_index :pessoas, name: "index_pessoas_searchable_short"
  end
end
