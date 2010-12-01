class Acl < ActiveRecord::Base
  validates :branch_id, :presence => true
  validates :maintainer_id, :presence => true
  validates :srpm_id, :presence => true

  belongs_to :branch
  belongs_to :maintainer
  belongs_to :srpm

  def self.import_acls(vendor, branch, url)
    b = Branch.where(:name => branch, :vendor => vendor).first
    if b.acls.count(:all) == 0
      ActiveRecord::Base.transaction do
        file = open(URI.escape(url)).read
        file.each_line do |line|
          package = line.split[0]
          for i in 1..line.split.count-1
            login = line.split[i]
            login = 'php-coder' if login == 'php_coder'
            login = 'p_solntsev' if login == 'psolntsev'
            login = '@vim-plugins' if login == '@vim_plugins'

            maintainer = Maintainer.where(:login => login).first
            srpm = b.srpms.where(:name => package).first

            if maintainer.nil?
              puts Time.now.to_s + ": maintainer not found '" + login + "'"
            elsif srpm.nil?
              puts Time.now.to_s + ": srpm not found '" + package + "'"
            else
              Acl.create(:srpm_id => srpm.id, :maintainer_id => maintainer.id, :branch_id => b.id)
            end
          end
        end
      end
    else
      puts Time.now.to_s + ": acls already imported"
    end
  end

  def self.create_acls_for_package(vendor, branch, url, package)
    b = Branch.where(:name => branch, :vendor => vendor).first
    b.srpms.where(:name => package).first.acls.delete_all
    file = open(URI.escape(url)).read
    file.each_line do |line|
      packagename = line.split[0]
      if packagename == package
        srpm = b.srpms.where(:name => packagename).first
        for i in 1..line.split.count-1
          login = line.split[i]
          login = 'php-coder' if login == 'php_coder'
          login = 'p_solntsev' if login == 'psolntsev'
          login = '@vim-plugins' if login == '@vim_plugins'
          maintainer = Maintainer.where(:login => login).first
          if maintainer.nil?
            puts Time.now.to_s + ": maintainer not found '" + login + "'"
          else
            Acl.create(:srpm_id => srpm.id, :maintainer_id => maintainer.id, :branch_id => b.id)
          end        
        end
      end
    end
  end
end
