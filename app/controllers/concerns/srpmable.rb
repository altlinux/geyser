module Srpmable
   extend ActiveSupport::Concern

   def fetch_spkg
      @spkgs = Package::Src.by_name(params[:reponame])
                          .by_evr(@evrb)
                          .joins(:branches, :branch_paths)
                          .order({version: :desc,
                                  release: :desc,
                                  buildtime: :asc},
                                 "branches.order_id")

      @spkg = @spkgs.in_branch(@branch).first&.decorate

      if !@spkg
         rpms = Rpm.joins(:package, :branch_path, :branch)
                   .by_name(params[:reponame])
                   .by_evr(@evrb)
                   .order({"packages.version": :desc,
                           "packages.release": :desc,
                           "packages.buildtime": :asc},
                           "branches.order_id")

         if (branch = rpms.first&.branch) && branch != @branch
            redirect_to url_for(branch: branch)
         else
            redirect_to home_url
         end
      end
   end

   def fetch_spkgs_by_name
      @spkgs_by_name = SrpmBranchesSerializer.new(Rpm.src
                                                     .by_name(params[:reponame])
                                                     .joins(:branch, :branch_path)
                                                     .includes(:branch_path, :branch, :package)
                                                     .order({"branches.order_id": :desc,
                                                             "packages.version": :desc,
                                                             "packages.release": :desc,
                                                             "packages.buildtime": :asc}))
   end
end
