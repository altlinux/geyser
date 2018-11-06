# frozen_string_literal: true

class Issue::FeatureRequest < Issue
   validates_presence_of :evr, :repo_name, :reported_at, :source_url

   def target_version
      /(?<version>[^-]+)-(?:[^-]+)\.src\.rpm$/ =~ source_url
      version
   end
end
