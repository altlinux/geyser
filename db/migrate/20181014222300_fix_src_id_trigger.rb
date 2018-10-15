class FixSrcIdTrigger < ActiveRecord::Migration[5.2]
   def change
      [
        "CREATE OR REPLACE FUNCTION packages_fillin_src_id() RETURNS trigger AS $$
                begin
                   IF new.type = 'Package::Src' THEN
                      new.src_id := new.id;
                   END IF;
                   return new;
                end
          $$ LANGUAGE plpgsql",
      ].each { |q| Branch.connection.execute(q) }
   end
end
