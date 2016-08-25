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
  
  # check for the setting that manages the label fields and set a default if not found
  unless AppConfig.has_key?(:container_management_labels)
    $stderr.puts "WARNING: container_management_labels plugin has no print fields set. Setting default values."
    AppConfig[:container_management_labels] = [
        {"institution_name" => {"checked" => true, "disabled" => false}},
        {"repository_name" => {"checked" => true, "disabled" => false}},
        {"resource_id" => {"checked" => true, "disabled" => false}},
        {"resource_title" => {"checked" => true, "disabled" => false}},
        {"agent_name" => {"checked" => true, "disabled" => false}},
        {"series_id" => {"checked" => false, "disabled" => false}},
        {"type" => {"checked" => false, "disabled" => false}},
        {"indicator" => {"checked" => true, "disabled" => true}},
        {"barcode" => {"checked" => false, "disabled" => false}},
        {"location" => {"checked" => false, "disabled" => false}},
        {"location_barcode" => {"checked" => false, "disabled" => false}}
    ]
  end
  
  # always ensure that the indicator will print and is not changeable
  #if AppConfig[:container_management_labels].find{|v| /container_indicator/ =~ v.to_s}.length > 0
  #    AppConfig[:container_management_labels].map!{|v|
  #      if v.to_s =~ /container_indicator/
  #        v = '"container_indicator" => {"checked" => true, "disabled" => true}'
  #      end
  #    }
  #else
  #  AppConfig[:container_management_labels].push("container_indicator" => {"checked" => true, "disabled" => true})
  #end
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