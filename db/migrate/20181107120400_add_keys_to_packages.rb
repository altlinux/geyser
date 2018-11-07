class AddKeysToPackages < ActiveRecord::Migration[5.2]
   def change
      change_table :packages do |t|
         t.string :keys, comment: "Ключи найденные в имени пакета"
      end

      reversible do |dir|
         dir.up do
            Package.find_each do |package|
               package.update_attribute(:keys, package.keys_fillin)
            end

            queries = [
#               TODO fix function use it instead of column
#               "CREATE OR REPLACE FUNCTION packages_name_to_keys(name text) RETURNS text AS $$
#                begin
#                   SELECT string_agg(key, ' ')
#                             FROM (
#                           SELECT DISTINCT key
#                             FROM (
#                           SELECT unnest(array_cat(regexp_split_to_array(name, E'[^a-zA-Z0-9]+'),
#                                                   regexp_split_to_array(name, E'[^a-zA-Z]+')))
#                               AS key)
#                               AS t1
#                            WHERE key <> '')
#                               AS t2;
#                end
#                $$ LANGUAGE plpgsql",
               "CREATE OR REPLACE FUNCTION packages_tsv_fillin() RETURNS trigger AS $$
                begin
                   new.tsv :=
                      setweight(to_tsvector(coalesce(new.name,'')), 'A') ||
                      setweight(to_tsvector(coalesce(new.keys,'')), 'A') ||
                      setweight(to_tsvector(coalesce(new.summary,'')), 'B') ||
                      setweight(to_tsvector(coalesce(new.description,'')), 'B') ||
                      setweight(to_tsvector(coalesce(new.url,'')), 'C');
                   return new;
                end
                $$ LANGUAGE plpgsql",
               "CREATE TRIGGER packages_trigger_tsv_update BEFORE INSERT OR UPDATE
                ON packages FOR EACH ROW EXECUTE PROCEDURE packages_tsv_fillin()",
               "UPDATE packages
                SET tsv = setweight(to_tsvector(coalesce(name,'')), 'A') ||
                          setweight(to_tsvector(coalesce(keys,'')), 'A') ||
                          setweight(to_tsvector(coalesce(summary,'')), 'B') ||
                          setweight(to_tsvector(coalesce(description,'')), 'B') ||
                          setweight(to_tsvector(coalesce(url,'')), 'C')",
               "DROP FUNCTION IF EXISTS packages_search_trigger() CASCADE"
            ]

            queries.each { |q| Branch.connection.execute(q) }
         end

         dir.down do
            queries = [
               "UPDATE packages
                SET tsv = setweight(to_tsvector(coalesce(name,'')), 'A') ||
                          setweight(to_tsvector(coalesce(summary,'')), 'B') ||
                          setweight(to_tsvector(coalesce(description,'')), 'B') ||
                          setweight(to_tsvector(coalesce(url,'')), 'A')",
               "CREATE OR REPLACE FUNCTION packages_search_trigger() RETURNS trigger AS $$
                begin
                   new.tsv :=
                      setweight(to_tsvector(coalesce(new.name,'')), 'A') ||
                      setweight(to_tsvector(coalesce(new.summary,'')), 'B') ||
                      setweight(to_tsvector(coalesce(new.description,'')), 'B') ||
                      setweight(to_tsvector(coalesce(new.url,'')), 'A');
                   return new;
                end
                $$ LANGUAGE plpgsql",
               "CREATE TRIGGER tsvectorupdate_for_packages BEFORE INSERT OR UPDATE
                ON packages FOR EACH ROW EXECUTE PROCEDURE packages_search_trigger()",
               "DROP FUNCTION IF EXISTS packages_tsv_fillin() CASCADE"
            ]

            queries.each { |q| Branch.connection.execute(q) }
         end
      end
   end
end
