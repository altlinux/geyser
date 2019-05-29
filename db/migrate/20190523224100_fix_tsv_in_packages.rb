class FixTsvInPackages < ActiveRecord::Migration[5.1]
   def change
      rename_column :packages, :tsv, :tsv1

      change_table :packages do |t|
         t.tsvector :tsv

         t.index %i(tsv), using: :gin
      end

      reversible do |dir|
         dir.up do
            queries = [
               "DROP TRIGGER tsvectorupdate_for_packages ON packages",
               "UPDATE packages
                SET tsv = setweight(to_tsvector(coalesce(regexp_replace(name, '[_.-]', ' ', 'g'),'')), 'A') ||
                          setweight(to_tsvector(coalesce(summary,'')), 'B') ||
                          setweight(to_tsvector(coalesce(description,'')), 'C') ||
                          setweight(to_tsvector(coalesce(url,'')), 'D')",
               "CREATE OR REPLACE FUNCTION packages_search_trigger() RETURNS trigger AS $$
                begin
                   new.tsv :=
                      setweight(to_tsvector(coalesce(regexp_replace(new.name, '[_.-]', ' ', 'g'),'')), 'A') ||
                      setweight(to_tsvector(coalesce(new.summary,'')), 'B') ||
                      setweight(to_tsvector(coalesce(new.description,'')), 'C') ||
                      setweight(to_tsvector(coalesce(new.url,'')), 'D');
                   return new;
                end
                $$ LANGUAGE plpgsql",
               "CREATE TRIGGER tsvectorupdate_for_packages BEFORE INSERT OR UPDATE
                ON packages FOR EACH ROW EXECUTE PROCEDURE packages_search_trigger()"
            ]

            queries.each { |q| Branch.connection.execute(q) }
         end

         dir.down do
         end
      end
   end
end
