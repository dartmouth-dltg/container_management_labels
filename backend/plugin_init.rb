  # check to see if archival object print levels has been set
  unless AppConfig.has_key?(:container_management_labels_print_levels)
    $stderr.puts " WARNING: container management_labels plugin has no print_levels parameter defined. " +
    "Setting default to print file labels only."
    AppConfig[:container_management_labels_print_levels] = ["file"]
  end