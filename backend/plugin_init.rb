# Any record supporting instances needs our compatibility mixin added as well.
# This allows mappings between ArchivesSpace containers and the new container
# model.
ASModel.all_models.each do |model|
  if model.included_modules.include?(Instances)
    model.include(MapToAspaceContainer)
  end
end
