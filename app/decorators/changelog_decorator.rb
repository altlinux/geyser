# frozen_string_literal: true

class ChangelogDecorator < Draper::Decorator
  delegate_all

  def as_json(*)
    {
      id: id,
      package_id: package_id,
      at: at,
      name: name,
      text: text,
      created_at: created_at.iso8601,
      updated_at: updated_at.iso8601
    }
  end
end
