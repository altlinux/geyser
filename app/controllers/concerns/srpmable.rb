module Srpmable
   extend ActiveSupport::Concern

   def fetch_spkg
      spkgs = Package::Src.by_name(params[:reponame])
                          .by_evr(@evrb)
                          .joins(:branches, :branch_paths)
                          .merge(BranchPath.published)
                          .order({version: :desc,
                                  release: :desc,
                                  buildtime: :desc},
                                 "branches.order_id")

      @spkg = spkgs.in_branch(@branch).first&.decorate

      if !@spkg
         rpms = Rpm.joins(:package, :branch_path, :branch)
                   .by_name(params[:reponame])
                   .by_evr(@evrb)
                   .merge(BranchPath.published)
                   .order({"packages.version": :desc,
                           "packages.release": :desc,
                           "packages.buildtime": :desc},
                           "branches.order_id")
         if branch = rpms.first.branch && branch != @branch
            redirect_to url_for(branch: branch)
         else
            raise ActiveRecord::ActiveRecordError.new
         end
      end
   end

   def fetch_spkgs_by_name
      @spkgs_by_name = SrpmBranchesSerializer.new(Rpm.src
                                                     .by_name(params[:reponame])
                                                     .joins(:branch, :branch_path)
                                                     .merge(BranchPath.published)
                                                     .includes(:branch_path, :branch, :package)
                                                     .order({"packages.version": :desc,
                                                             "packages.release": :desc,
                                                             "packages.buildtime": :desc},
                                                             "branches.order_id"))
   end
end
