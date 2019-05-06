# frozen_string_literal: true

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = Rails.configuration.action_mailer.default_url_options[:host]

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

  ['en', 'ru'].each do |locale|
    Branch.find_each do |branch|
      add home_path(locale, branch)
      add packages_path(locale, branch)
      add maintainers_path(locale, branch)
      add security_path(locale, branch)
      add project_path(locale)
      add rss_path(locale, branch)

      branch.spkgs.find_each do |srpm|
        add srpm_path(locale, branch, srpm)
        add changelogs_path(locale, branch, srpm)
        add specfile_path(locale, branch, srpm)
        add patches_path(locale, branch, srpm)
        add sources_path(locale, branch, srpm)
        add issues_path(locale, branch, srpm)
        add repocop_notes_path(locale, branch, srpm)
        add repos_gears_path(locale, branch, srpm)
        add pkg_index_tasks_path(locale, branch, srpm)
      end
    end
  end
end
