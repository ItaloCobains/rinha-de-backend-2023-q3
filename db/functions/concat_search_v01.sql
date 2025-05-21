CREATE OR REPLACE FUNCTION concat_search(_nome VARCHAR, _apelido VARCHAR, _stack JSON)
  RETURNS TEXT AS $$
  BEGIN
  RETURN _nome || _apelido || _stack;
  END;
$$ LANGUAGE plpgsql IMMUTABLE;

