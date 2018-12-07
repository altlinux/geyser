class MergeMaintainers
   attr_reader :source, :target

   def do
      ApplicationRecord.transaction do
         merge_maintainer
         merge_packages
         merge_gear_maintainers
         merge_issue_assignees
         merge_branching_maintainers
         merge_changelogs
         merge_emails

         source.destroy!
      end
   end

   protected

   def cleaned attrs
      attrs.to_a.select {|(attr, value)| value.present? && [ attr, value] || nil }.compact.to_h
   end

   def merge_maintainer
      attrs = cleaned(source.as_json(except: %i(created_at updated_at id email)))
       .merge(cleaned(target.as_json(except: %i(created_at updated_at id email))))

      target.update!(attrs)
   end
       
   def merge_gear_maintainer gm, tgm
      attrs = {
         created_at: [ gm.created_at, tgm.created_at ].min,
         updated_at: [ gm.updated_at, tgm.updated_at ].max,
      }

      tgm.update!(attrs)
   end

   def merge_branching_maintainer bm, tbm
      tbm.update_attribute(:srpms_count, [ bm.srpms_count, tbm.srpms_count ].max)
   end

   def merge_packages
      source.packages.update_all(builder_id: target.id)
   end

   def merge_issue_assignees
      source.issue_assignees.update_all(maintainer_id: target.id)
   end

   def merge_gear_maintainers
      source.gear_maintainers.find_each do |gm|
         GearMaintainer.where(maintainer_id: target.id, gear_id: gm.gear).each do |tgm|
            merge_gear_maintainer(gm, tgm)

            gm.destroy!
         end
      end

      source.gear_maintainers.update_all(maintainer_id: target.id)
   end

   def merge_branching_maintainers
      source.branching_maintainers.find_each do |bm|
         BranchingMaintainer.where(maintainer_id: target.id, branch_id: bm.branch).each do |tbm|
            merge_branching_maintainer(bm, tbm)

            bm.destroy!
         end
      end

      source.branching_maintainers.update_all(maintainer_id: target.id)
   end

   def merge_changelogs
      source.changelogs.update_all(maintainer_id: target.id)
   end

   def merge_emails
      source.emails.update_all(maintainer_id: target.id)
   end

   def initialize source: nil, target: nil
      @source = source
      @target = target
   end
end
