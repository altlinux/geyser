class HomeController < ApplicationController
#  caches_page :index, :project, :news, :security, :rss, :groups_list, :bygroup, :maintainers_list

#  caches_page :index

  def index
    @branch = Branch.where(:name => 'Sisyphus', :vendor => 'ALT Linux').first
    @top15 = Maintainer.top15
    @srpms = @branch.srpms.where("srpms.created_at > '2010-11-09 09:00:00'").includes(:group, :maintainer).order('srpms.created_at DESC').paginate(:page => params[:page], :per_page => 100)
  end

  def search
    @branch = Branch.where(:name => 'Sisyphus', :vendor => 'ALT Linux').first
    if params[:request].nil?
      redirect_to :action => "index"
    else
      @search = Srpm.search(:name_or_summary_or_description_contains_all => params[:search].to_s.split).where(:branch_id => @branch.id).order("name ASC")
      @srpms, @srpms_count = @search.all, @search.count
    end
  end

  def groups_list
    @branch = Branch.where(:name => 'Sisyphus', :vendor => 'ALT Linux').first
    @groups = @branch.groups.find(:all, :conditions => {:parent_id => nil}, :order => 'LOWER(name)')
  end

  def bygroup
    # TODO: branch can be not only Sisyphus!
    @branch = Branch.where(:name => 'Sisyphus', :vendor => 'ALT Linux').first
    @group = @branch.groups.find(:first, :conditions => { :name => params[:group], :parent_id => nil })
    if !params[:group2].nil?
      @group = @branch.groups.find(:first, :conditions => { :name => params[:group2], :parent_id => @group.id })
      if !params[:group3].nil?
        @group = @branch.groups.find(:first, :conditions => { :name => params[:group3], :parent_id => @group.id })
      end
    end
    @srpms = @group.srpms.find(:all, :order => 'LOWER(name)')
  end

  def maintainers_list
    @maintainers = Maintainer.find_all_maintainers_in_sisyphus
    @teams = Maintainer.find_all_teams_in_sisyphus
  end
  
  def fresh_srpms_rss
    @branch = Branch.where(:name => 'Sisyphus', :vendor => 'ALT Linux').first
    @srpms = @branch.srpms.where("srpms.created_at > ?", Time.now - 2.day).includes(:group, :maintainer).order('srpms.created_at DESC').all
    render :layout => nil
    response.headers["Content-Type"] = "application/xml; charset=utf-8"
  end
end