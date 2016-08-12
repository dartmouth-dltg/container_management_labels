Container Management Label Addon
================================

WIP: ArchivesSpace plugin to add the ability to print labels within the browser to ArchivesSpace.

This plugin was originally a fork of https://github.com/hudmol/container_management
It is compatible with ArchivesSpace v1.5.1+


## Installing it

To install, just activate the plugin in your config/config.rb file by
including an entry such as:

     # If you have other plugins loaded, just add 'container_management' to
     # the list
     AppConfig[:plugins] = ['local', 'other_plugins', 'container_management_labels']
     
## Modifying

The labels that are available to print from within the browser are defined in four (4) files:

/frontend/assets/container_labels.css

     This is where the CSS is defined for the label fields and for the specific layouts. Note the convention
     of using the label name as a namespace, eg ".dymo-30256"
    
/frontend/views/labels/_bulk_action_labels.html.erb

    The page sizing for the @page CSS directive is defined for each type at the beginning of this file.
    The definition is in the form of a hash:
    page_sizing = {
        "dymo-30256" => {"size" => "59mm 102mm", "margin" => "5mm 1mm 5mm 1mm"},
        "avery-5163" => {"size" => "letter", "margin" => "0.5in 0.125in"}
    }
    The @page definitions are written on load depending on the label type selected.
    
/frontend/views/labels/_labels_bulk_action_templates.html.erb

    Each type of label must be included here as a select option.
    
/locales/en.yml

    The translations for each label are defined here. For example.
        label_type_dymo_30256: Dymo-30256

## Note

This plugin requires the container management integration in ArchivesSpace v1.5.1+.
It is *only* configured for one label size and assumes certain fields will be present.
Some local customzation will be required.