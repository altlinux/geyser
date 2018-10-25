# frozen_string_literal: true

class Issue::Ftbfs < Issue
   validates_presence_of :status, :severity, :branch_path, :evr, :repo_name, :reported_at
end
