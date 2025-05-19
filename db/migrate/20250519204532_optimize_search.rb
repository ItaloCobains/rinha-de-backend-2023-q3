class OptimizeSearch < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      DROP INDEX IF EXISTS idx_pessoas_concat_trgm;
      -- gera o valor em lower() uma única vez no SELECT ou no índice
      CREATE EXTENSION IF NOT EXISTS pg_trgm;

      -- índice GiST de trigramas sobre a expressão
      CREATE INDEX idx_pessoas_concat_trgm_gist
        ON pessoas
        USING GIST (lower(apelido || nome || stack::text) gist_trgm_ops);
    SQL
  end
end
