# frozen_string_literal: true

require 'open-uri'

class ImportAcls
   MAP = {
      'php_coder' => 'php-coder',
      'psolntsev' => 'p_solntsev',
      '@vim_plugins' => '@vim-plugins',
   }

   attr_reader :branch

   def do
      branch.branch_paths.src.each do |branch_path|
         if url = branch_path.acl_url
            add_acls_from(url, branch_path)
            remove_acls_from(url, branch_path)
         end
      end
   end

   protected

   def initialize branch: nil
      @branch = branch
      @file = {}
   end

   def file url
      @file[url] ||= open(URI.escape(url)).read
   rescue OpenURI::HTTPError
      ''
   end

   def acls_hash url
      file(url).split("\n").map do |line|
        tokens = line.split
        [ tokens.shift, tokens.map { |t| MAP[t] || t } ]
      end.to_h
   end

   def acls url
      file(url).split("\n").map do |line|
        tokens = line.split
        package_name = tokens.shift
        tokens.map.with_index { |t, i| [ package_name, MAP[t] || t, i == 0 ] }
      end.flatten(1)
   end

   def add_acls_from url, branch_path
      attrs = acls(url).map do |(package_name, maintainer_slug, owner)|
         {
            package_name: package_name,
            maintainer_slug: maintainer_slug,
            branch_path_id: branch_path.id,
            owner: owner
         }
      end

      Acl.import!(attrs, on_duplicate_key_update: {
                           conflict_target: %i(package_name maintainer_slug branch_path_id),
                           columns: %i(owner)})
   end

   def remove_acls_from url, branch_path
      acls_hash(url).each do |package_name, maintainers|
         Acl.where(package_name: package_name, branch_path_id: branch_path.id).where.not(maintainer_slug: maintainers).delete_all
      end
   end
end
