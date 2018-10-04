# frozen_string_literal: true

require 'open-uri'

class ImportTeams
   MAP = {
      'php_coder' => 'php-coder',
      'psolntsev' => 'p_solntsev',
      '@vim_plugins' => '@vim-plugins',
   }

   attr_reader :branch

   def do
      branch.branch_paths.src.each do |branch_path|
         if url = branch_path.team_url
            add_teams_from(url, branch_path)
            remove_teams_from(url, branch_path)
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

   def teams_hash url
      file(url).split("\n").map do |line|
        tokens = line.split
        tm = tokens.shift
        [ MAP[tm] || tm, tokens.map { |t| MAP[t] || t } ]
      end.to_h
   end

   def teams url
      file(url).split("\n").map do |line|
        tokens = line.split
        tm = tokens.shift
        tokens.map.with_index { |t, i| [ MAP[tm] || tm, MAP[t] || t ] }
      end.flatten(1)
   end

   def add_teams_from url, branch_path
      attrs = teams(url).map do |(team_slug, person_slug)|
         {
            branch_path_id: branch_path.id,
            team_slug: team_slug,
            person_slug: person_slug,
         }
      end

      TeamPerson.import!(attrs, on_duplicate_key_ignore: true)
   end

   def remove_teams_from url, branch_path
      teams_hash(url).each do |team_slug, people_slugs|
         TeamPerson.where(team_slug: team_slug,
                          branch_path_id: branch_path.id)
                   .where.not(person_slug: people_slugs)
                   .delete_all
      end
   end
end
