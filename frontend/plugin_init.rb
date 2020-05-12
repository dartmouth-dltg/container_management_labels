ArchivesSpace::Application.extend_aspace_routes(File.join(File.dirname(__FILE__), "routes.rb"))

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
  
  # define a default set of fields
  # used as a default and as a check against the fields set in config.rb
  label_default = [
        {"institution_name" => {"checked" => true, "disabled" => false}},
        {"repository_name" => {"checked" => true, "disabled" => false}},
        {"resource_id" => {"checked" => true, "disabled" => false}},
        {"indicator" => {"checked" => true, "disabled" => true}},
        {"resource_title" => {"checked" => true, "disabled" => false}},
        {"agent_name" => {"checked" => true, "disabled" => false}},
        {"series_id" => {"checked" => false, "disabled" => false}},
        {"type" => {"checked" => false, "disabled" => false}},
        {"barcode" => {"checked" => false, "disabled" => false}},
        {"area" => {"checked" => true, "disabled" => false}},
        {"location" => {"checked" => true, "disabled" => false}},
        {"location_barcode" => {"checked" => false, "disabled" => false}}
    ]
    
  # check for the setting that manages the label fields and set a default if not found
  unless AppConfig.has_key?(:container_management_labels)
    $stderr.puts "WARNING: container_management_labels plugin has no print fields set. Setting default values."
    AppConfig[:container_management_labels] = label_default
  end
  
  # remove any hashes if the key is *not* included in the default list
  label_default_keys = label_default.map{|l| l.keys}.flatten
  
  AppConfig[:container_management_labels].each {|hash|
    hash.delete_if { |k|
      !label_default_keys.include?(k)
    }
   }.delete_if {|hash| hash.empty?}
      
  # check to see if any page sizes have been defined
  unless AppConfig.has_key?(:container_management_labels_pagesize)
    $stderr.puts "WARNING: container_management_labels plugin has no page sizes defined. " +
    "Printing may not work as expected and will default to a standard letter size."
    AppConfig[:container_management_labels_pagesize] = {}
  end
  
  # check to see if autoscaling has been defined
  unless AppConfig.has_key?(:container_management_labels_autoscale)
    $stderr.puts "WARNING: container_management_labels plugin has no autoscale parameter defined. " +
    "Adding default for autoscale."
    AppConfig[:container_management_labels_autoscale] = {}
  end
  
  # check to see if printing files has been defined
  unless AppConfig.has_key?(:container_management_labels_print_files)
    $stderr.puts "WARNING: container_management_labels plugin has no print_files parameter defined. " +
    "Adding default for printing files."
    AppConfig[:container_management_labels_print_files] = {}
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