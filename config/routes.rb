# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  authenticate :user, ->(user) { user.admin? } do
    mount PgHero::Engine, at: 'pghero'
  end

  namespace :api, defaults: { format: 'json' } do
    resources :docs, only: :index

    resources :branches, only: [:index, :show]

    resources :bugs, only: :show

    resources :srpms, id: /[^\/]+/, only: [:index, :show] do
      resources :packages, id: /[^\/]+/, only: :index

      resources :changelogs, id: /[^\/]+/, only: :index
    end

    resources :packages, id: /[^\/]+/, only: :show, controller: :package

    resources :maintainers, only: [:index, :show]
  end

   scope '(:locale)', locale: SUPPORTED_LOCALES_RE do
    devise_for :users

    root to: 'home#index'

    # support old rules
    # from v2
    get ':branch/srpms/:reponame/gear', to: redirect('/%{locale}/%{branch}/srpms/%{reponame}')
    # from v1
    get 'srpm/:branch/:reponame', to: redirect('/%{locale}/%{branch}/srpms/%{reponame}')
    get 'srpm/:branch/:reponame/changelog', to: redirect('/%{locale}/%{branch}/srpms/%{reponame}/changelog')
    get 'srpm/:branch/:reponame/spec', to: redirect('/%{locale}/%{branch}/srpms/%{reponame}/spec')
    get 'srpm/:branch/:name/patches', to: redirect('/%{locale}/%{branch}/srpms/%{name}/patches')
    get 'srpm/:branch/:reponame/sources', to: redirect('/%{locale}/%{branch}/srpms/%{reponame}/sources')
    get 'srpm/:branch/:reponame/get', to: redirect('/%{locale}/%{branch}/srpms/%{reponame}/get')
    get 'srpm/:branch/:reponame/gear', to: redirect('/%{locale}/%{branch}/srpms/%{reponame}')
    get 'srpm/:branch/:reponame/bugs', to: redirect('/%{locale}/%{branch}/srpms/%{reponame}/bugs')
    get 'srpm/:branch/:reponame/repocop', to: redirect('/%{locale}/%{branch}/srpms/%{reponame}/repocop')
    get 'people', to: redirect('/%{locale}/sisyphus/maintainers')
    get 'packager/:login', to: redirect('/%{locale}/sisyphus/maintainers/%{login}')
    get 'team/:login', to: redirect('/%{locale}/sisyphus/teams/%{login}')
    get 'packages', to: redirect('/%{locale}/sisyphus/packages'), as: :old_packages
    get 'packages/:group1', to: redirect { |pp, _| "/#{pp[:locale]}/sisyphus/packages/#{pp[:group1].downcase}" }
    get 'packages/:group1/:group2', to: redirect { |pp, _| "/#{pp[:locale]}/sisyphus/packages/#{pp[:group1].downcase}_#{pp[:group2].downcase}" }
    get 'packages/:group1/:group2/:group3', to: redirect { |pp, _| "/#{pp[:locale]}/sisyphus/packages/#{pp[:group1].downcase}_#{pp[:group2].downcase}_#{pp[:group3].downcase}" }

    get 'project' => 'pages#project'

      scope '(:branch)', branch: /([^\/]+)/ do
         get 'srpms/:reponame/repocop' => 'srpm_repocops#index', reponame: /[^\/]+/, branch: /sisyphus/, as: 'repocop_srpm'

         get 'srpms/:reponame/bugs' => 'srpm_opened_bugs#index', reponame: /[^\/]+/, as: 'bugs_srpm'
         get 'srpms/:reponame/allbugs' => 'srpm_all_bugs#index', reponame: /[^\/]+/, as: 'allbugs_srpm'

         resources :srpms, param: :name, name: /[^\/]+/, only: :show do
            member do
               get 'changelog'
               get 'spec'
               get 'rawspec'
               get 'get'
            end

            resources :sources, param: :reponame, only: :index do
               resource :download, only: :show, controller: :source_download
            end
         end

         scope :srpms do
            scope '(:name)', name: /[^\/]+/ do
               scope '(:evrb)', evrb: /[^\/]+/ do
                  resources :patches, param: :patch_name, only: %i(index show) do
                     get 'download', on: :member
                  end
               end

               resources :patches, param: :patch_name, only: %i(index show) do
                  get 'download', on: :member
               end
#               get 'patches' => 'patches#index'
#               get 'patches/:patch' => 'patches#show', patch: /[^\/]+/
#               get 'patches/:patch/download' => 'patches#download', patch: /[^\/]+/
            end

         end

      # patches

      get 'sources/:srpm_reponame/:version/index' => 'sources#index', srpm_reponame: /[^\/]+/, version: /[^\/]+/, as: 'versioned_srpm_sources'
      get 'sources/:srpm_reponame/:version/download' => 'sources#download', srpm_reponame: /[^\/]+/, version: /[^\/]+/, as: 'versioned_srpm_source_download'
      get 'srpms/:reponame/:version/bugs' => 'srpm_opened_bugs#index', reponame: /[^\/]+/, version: /[^\/]+/, branch: /sisyphus/, as: 'versioned_bugs_srpm'
      get 'srpms/:reponame/:version/allbugs' => 'srpm_all_bugs#index',  reponame: /[^\/]+/, version: /[^\/]+/, branch: /sisyphus/, as: 'versioned_allbugs_srpm'
      get 'srpms/:reponame/:version/repocop' => 'srpm_repocops#index',  reponame: /[^\/]+/, version: /[^\/]+/, branch: /sisyphus/, as: 'versioned_repocop_srpm'

      get 'srpms/:reponame/:version' => 'srpms#show', reponame: /[^\/]+/, version: /[^\/]+/, as: 'versioned_srpm'
      get 'srpms/:reponame/:version/changelog' => 'srpms#changelog', reponame: /[^\/]+/, version: /[^\/]+/, as: 'versioned_changelog_srpm'
      get 'srpms/:reponame/:version/spec' => 'srpms#spec', reponame: /[^\/]+/, version: /[^\/]+/, as: 'versioned_spec_srpm'
      get 'srpms/:reponame/:version/rawspec' => 'srpms#rawspec', reponame: /[^\/]+/, version: /[^\/]+/, as: 'versioned_rawspec_srpm'
      get 'srpms/:reponame/:version/get' => 'srpms#get', reponame: /[^\/]+/, version: /[^\/]+/, as: 'versioned_get_srpm'

      get 'rss' => 'rss#index', as: 'rss'
      resources :teams, only: [:index, :show]

      resources :maintainers, only: :index
      get 'maintainers/:id/gear' => 'maintainers#gear', as: 'gear_maintainer'
      get 'maintainers/:id/bugs' => 'maintainers#bugs', as: 'bugs_maintainer'
      get 'maintainers/:id/allbugs' => 'maintainers#allbugs', as: 'allbugs_maintainer'
      get 'maintainers/:id/ftbfs' => 'maintainers#ftbfs', as: 'ftbfs_maintainer'
      get 'maintainers/:id/watch' => 'maintainers#novelties', as: 'novelties_maintainer'
      get 'maintainers/:id/repocop' => 'maintainers#repocop', as: 'repocop_maintainer'

      get 'packages/:slug' => 'group#show', slug: /[a-z_]+/, as: 'group'
      get 'packages' => 'group#index', as: 'packages'
      get 'security' => 'security#index', as: 'security'

      #get '/', to: redirect('/%{locale}/%{branch}/home')

      # old routes
      get 'packages/:group1', to: redirect { |pp, _| "/#{pp[:locale]}/#{pp[:branch]}/packages/#{pp[:group1].downcase}" }
      get 'packages/:group1/:group2', to: redirect { |pp, _| "/#{pp[:locale]}/#{pp[:branch]}/packages/#{pp[:group1].downcase}_#{pp[:group2].downcase}" }
      get 'packages/:group1/:group2/:group3', to: redirect { |pp, _| "/#{pp[:locale]}/#{pp[:branch]}/packages/#{pp[:group1].downcase}_#{pp[:group2].downcase}_#{pp[:group3].downcase}" }
    end

    resource :maintainer_profile, only: [:edit, :update]
    resource :search, only: :show
    resources :rebuild, controller: :rebuild, only: :index
    resources :rsync, controller: :rsync, only: %i(new) do
       post :generate, on: :collection
    end

    scope ':branch', branch: /([^\/]+)/ do
      resources :maintainers, only: :show do
        get 'srpms', on: :member
        resources :activity, only: :index, controller: :maintainer_activity
      end
    end
  end

  scope ':locale', locale: SUPPORTED_LOCALES_RE do
    scope ':branch', branch: /([^\/]+)/ do
      get 'home' => 'home#index'
    end
  end

   resources :repocop_patches, only: [], param: 'package_id' do
      get :download
   end

  get '(/:locale)/misc/bugs' => 'misc#bugs', locale: SUPPORTED_LOCALES_RE

  # TODO: drop this later
  # get '/repocop' => 'repocop#index'
  # get '/repocop/by-test/:testname' => 'repocop#bytest'
  #
  # get '/repocop/by-test/install_s' => 'repocop#srpms_install_s'

  # TODO: drop this and make API
  get '/repocop/no_url_tag' => 'repocop#no_url_tag'
  get '/repocop/invalid_url' => 'repocop#invalid_url'
  get '/repocop/invalid_vendor' => 'repocop#invalid_vendor'
  get '/repocop/invalid_distribution' => 'repocop#invalid_distribution'
  get '/repocop/srpms_summary_too_long' => 'repocop#srpms_summary_too_long'
  get '/repocop/packages_summary_too_long' => 'repocop#packages_summary_too_long'
  get '/repocop/srpms_summary_ended_with_dot' => 'repocop#srpms_summary_ended_with_dot'
  get '/repocop/packages_summary_ended_with_dot' => 'repocop#packages_summary_ended_with_dot'
  get '/repocop/srpms_filename_too_long_for_joliet' => 'repocop#srpms_filename_too_long_for_joliet'
  get '/repocop/packages_filename_too_long_for_joliet' => 'repocop#packages_filename_too_long_for_joliet'
  get '/repocop/srpms_install_s' => 'repocop#srpms_install_s'
  # END

  get '/src::name' => 'srpm_redirector#index', name: /[^\/]+/

  get '/:name' => 'redirector#index', name: /[^\/]+/
end
