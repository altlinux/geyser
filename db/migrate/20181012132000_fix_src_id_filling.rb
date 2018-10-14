class FixSrcIdFilling < ActiveRecord::Migration[5.2]
   def change
      change_table :specfiles do |t|
         t.text :text
         t.tsvector :tsv

         t.index %i(tsv), using: :gin
      end

      [
        "CREATE OR REPLACE FUNCTION packages_fillin_src_id() RETURNS trigger AS $$
                begin
                   IF new.type = 'Package::Src' THEN
                      new.src_id := new.id;
                   END IF;
                   return new;
                end
          $$ LANGUAGE plpgsql",
        "UPDATE specfiles
            SET text = encode(specfiles.spec, 'escape')",
        "UPDATE specfiles
            SET tsv = setweight(to_tsvector(coalesce(text,'')), 'A')",
     "CREATE OR REPLACE FUNCTION specfiles_fillin_text() RETURNS trigger AS $$
                begin
                   new.tsv := setweight(to_tsvector(coalesce(new.text,'')), 'A');
                   return new;
                end
                $$ LANGUAGE plpgsql",
        "CREATE TRIGGER specfiels_fillin_text_trigger BEFORE INSERT
             ON specfiles FOR EACH ROW EXECUTE PROCEDURE specfiles_fillin_text()",
      ].each { |q| Branch.connection.execute(q) }
   end
end
