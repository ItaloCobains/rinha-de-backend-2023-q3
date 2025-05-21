class AddSomeIndexOnPessoa < ActiveRecord::Migration[8.0]
  def up
    add_index :pessoas, :apelido, unique: true, name: "index_pessoas_on_apelido"

    execute <<~SQL
      CREATE INDEX index_pessoas_on_searchable_text_trgm_gist
      ON pessoas
      USING gist (searchable_text gist_trgm_ops);
    SQL
  end

  def down
    remove_index :pessoas, name: "index_pessoas_on_apelido"

    execute <<~SQL
      DROP INDEX index_pessoas_on_searchable_text_trgm_gist;
    SQL
  end
end
