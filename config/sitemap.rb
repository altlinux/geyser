# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = 'https://packages.altlinux.org'

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: priority: 0.5, changefreq: 'weekly',
  #           lastmod: Time.now, host: default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, priority: 0.7, changefreq: 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), lastmod: article.updated_at
  #   end

  add '/', changefreq: 'hourly'
  add '/en', changefreq: 'hourly'
  add '/ru', changefreq: 'hourly'
  add '/uk', changefreq: 'hourly'
  add '/br', changefreq: 'hourly'

  ['en', 'ru', 'uk', 'br'].each do |locale|
    Branch.find_each do |branch|
      add home_path(locale, branch)
      add packages_path(locale, branch)
      add maintainers_path(locale, branch)
      add security_path(locale, branch)
      add project_path(locale)
      add rss_path(locale, branch)

      branch.srpms.find_each do |srpm|
        add srpm_path(locale, branch, srpm)
        add changelog_srpm_path(locale, branch, srpm)
        add spec_srpm_path(locale, branch, srpm)
        add srpm_patches_path(locale, branch, srpm)
        add srpm_sources_path(locale, branch, srpm)
        add get_srpm_path(locale, branch, srpm)
        add gear_srpm_path(locale, branch, srpm)
        add bugs_srpm_path(locale, srpm)
        add allbugs_srpm_path(locale, srpm)
        add repocop_srpm_path(locale, srpm)
      end
    end
  end
end
