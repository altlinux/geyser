# frozen_string_literal: true

require 'terrapin'

class ImportGears
   MAP = {
      'php_coder' => 'php-coder',
      'psolntsev' => 'p_solntsev',
      '@vim_plugins' => '@vim-plugins',
   }

   attr_reader :url, :path

   def do
      Gear.import!(gear_attrs, on_duplicate_key_update: { conflict_target: %i(url),
                                                          columns: %i(changed_at updated_at) })
   end

   protected

   def initialize url: nil, path: nil
      @url = url
      @path = path
   end

   def parse result
      if result !~ /\A\z/
         result.force_encoding('utf-8').split("\n").map do |line|
            /'.*?(?<kind>gear|srpm)s\/(?<first>\w)\/(?<reponame>[^\/]+)\.git'\s(?<timestamp>\d+)/ =~ line

            if kind
               {
                  url: File.join(url, kind.pluralize, reponame[0], "#{reponame}.git"),
                  reponame: reponame,
                  kind: kind,
                  updated_at: Time.at(timestamp.to_i),
                  changed_at: Time.at(timestamp.to_i)
               }
            else
               Rails.logger.info("IMPORT.GEAR: failed to parse line #{line}")
            end
         end.compact
      end
   end

   def gear_attrs
      fullpath = File.expand_path(path)
      depth = 2 + fullpath.count('/')
      args = "#{fullpath} -maxdepth #{depth} -name *.git -type d -exec stat -c '%N %Y' {} \\;"

      Rails.logger.info("IMPORT.GEAR: find with args #{args}")
      wrapper = Terrapin::CommandLine.new('find', args, environment: { 'LANG' => 'C', 'LC_ALL' => 'en_US.UTF-8' })

      parse(wrapper.run)
   rescue Terrapin::CommandNotFoundError
      Rails.logger.info('IMPORT.GEAR: find command not found')
   rescue Terrapin::ExitStatusError
      Rails.logger.info('IMPORT.GEAR: find exit status non zero')
   end
end
