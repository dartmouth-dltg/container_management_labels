Container Management Label Addon
================================

ArchivesSpace plugin to add the ability to print labels within the browser to ArchivesSpace.

This plugin is a fork of https://github.com/hudmol/container_management
It is compatible with ArchivesSpace v1.5


## Installing it

To install, just activate the plugin in your config/config.rb file by
including an entry such as:

     # If you have other plugins loaded, just add 'container_management' to
     # the list
     AppConfig[:plugins] = ['local', 'other_plugins', 'container_management_labels']

## Note

This plugin requires the container management integration in ArchivesSpace v1.50+. It is *only* configured for one label size and assumes certain fields will be present. Some local customzation wil be required.