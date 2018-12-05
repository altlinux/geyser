# frozen_string_literal: true

class BranchDecorator < Draper::Decorator
  include Draper::LazyHelpers

  delegate_all

  def as_json(*)
    {
      id: id,
      name: name,
      order_id: order_id,
      path: path,
      created_at: created_at.iso8601,
      updated_at: updated_at.iso8601,
      count: spkgs.count
    }
  end

  def default_arches
    %w(i586 x86_64 aarch64 mipsel armh)
  end

  def options_for arch
    h.content_tag(:option, _("All arches"), value: '') +
      options_from_collection_for_select(default_arches, :freeze, :freeze, arch)
  end

  def branches_as_options branches, branch_slug
    h.content_tag(:option, _("All branches"), value: '') +
      options_from_collection_for_select(branches, :slug, :name, branch_slug)
  end
end
