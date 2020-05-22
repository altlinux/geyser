module Srpmable
   extend ActiveSupport::Concern

   def fetch_spkg
      spkgs = Package::Src.in_branch(@branch)
                          .by_name(params[:reponame])
                          .by_evr(@evrb)
                          .joins(:branches, :branch_paths)
                          .merge(BranchPath.published)
                          .order({version: :desc,
                                  release: :desc,
                                  buildtime: :desc},
                                 "branches.order_id")

      @spkg = spkgs.first!.decorate
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
