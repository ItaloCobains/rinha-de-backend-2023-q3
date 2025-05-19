psql -h localhost -p 5433 -U postgres rails_app -c 'TRUNCATE pessoas;'
mvn gatling:test