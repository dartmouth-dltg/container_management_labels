my_routes = [File.join(File.dirname(__FILE__), "routes.rb")]
ArchivesSpace::Application.config.paths['config/routes'].concat(my_routes)

Rails.application.config.after_initialize do
  
  begin
    JSONModel(:top_container)
  rescue
    puts("Couldn't find JSONModel(:top_container)\n" +
         "\n" +
         "The container_management_labels plugin depends on container_management. Be sure to include the container_management plugin or to be running ArchivesSpace v1.5 or greater.\n\n" +
         "Please check your configuration and try again.")
    raise "Plugin dependency not satisfied - container_management_labels requires container_management"
  end
  
  # check to see if any page sizes have been defined
  unless AppConfig.has_key?(:container_management_labels_pagesize)
    $stderr.puts "WARNING: container_management_labels plugin has no page sizes defined. " +
    "Printing may not work as expected and will default to a standard letter size."
    AppConfig[:container_management_labels_pagesize] = {}
  end
  
  # add the default page sizing in any case
  AppConfig[:container_management_labels_pagesize]['default'] = {"size" => "letter", "margin" => "0.25in"}
  
  ActionView::PartialRenderer.class_eval do
    alias_method :render_labels, :render
    def render(context, options, block)
      result = render_labels(context, options, block);

      # Add our location-specific templates to shared/templates
      if options[:partial] == "shared/templates"
        result += render(context, options.merge(:partial => "labels/labels_bulk_action_templates"), nil)
      end

      result
    end
  end

end