class AddTrgmIndexesToPessoas < ActiveRecord::Migration[8.0]
  def up

    execute <<~SQL
      CREATE INDEX idx_pessoas_concat_trgm
      ON pessoas
      USING GIN (lower(apelido || nome || stack::text) gin_trgm_ops);
    SQL
  end

  def down
    execute <<~SQL
      DROP INDEX IF EXISTS idx_pessoas_concat_trgm;
    SQL
  end
end
