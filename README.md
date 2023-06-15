Container Management Label Plugin
================================

ArchivesSpace plugin to add the ability to print labels within the browser to ArchivesSpace.
It is compatible with ArchivesSpace v1.5.1+ (See different releases for different versions)

## Note

Please see release notes to ensure you are using the correct version of the plugin for your
version of ArchivesSpace.

## Overview

This plugin was originally a fork of https://github.com/hudmol/container_management

The plugin adds a new option to the Bulk Operations menu in the Manage Top Containers view. The new menu option allows
a user to print labels directly from the browser. The user can select which fields to add to the label, what barcode type
to use if any of the selected fields are barcode fields and what label type to print.

It supports two label sizes on install:

    Dymo 30256 (59mm x 102mm, portrait, thermal roll)
    Avery 5163 (2in x 5in, letter, portrait)
    
Some local customization will be required to add additional label types and orientations. Additional css customizations may be necessary for
local browser and printer combinations.

## Installing

To install, just activate the plugin in your config.rb file by
including an entry such as:

     # If you have other plugins loaded, just add 'container_management_labels' to the list
     AppConfig[:plugins] = ['local', 'other_plugins', 'container_management_labels']
     
Note that this plugin overrides two core views files

    /frontend/views/top_containers/bulk_operations/_search_criteria.html.erb
    /frontend/views/top_containers/bulk_operations/_toolbar.html.erb
    
If you have other plugins that override these same files, you will need to reconcile the two.
     
## Configuring & Modifying

The labels that are available to print from within the browser are defined in two (2) plugin files and the config.rb file.

### config.rb file

Define the fields and order in which they should appear on the label. The fields must be a member of the following list unless
additional fields are set in the model (`backend/model/label_data.rb`)

    institution_name
    repository_name
    resource_id
    resource_title
    agent_name
    type
    indicator
    barcode
    location
    area
    location_barcode
    
Each key should also indicate whether the field will be a default ("checked" => true) and whether the end user
should be able to change it ("disabled" => false). The following are the default settings and are set automatically if the
config file does not contain the `:container_management_labels` key.
    
    AppConfig[:container_management_labels] = [
        {"institution_name" => {
            "checked" => true,
            "disabled" => false}},
        {"repository_name" => {
            "checked" => true,
            "disabled" => false}},
        {"resource_id" => {
            "checked" => true,
            "disabled" => false}},
        {"resource_title" => {
            "checked" => true,
            "disabled" => false}},
        {"agent_name" => {
            "checked" => true,
            "disabled" => false}},
        {"series_id" => {
            "checked" => false,
            "disabled" => false}},
        {"type" => {
            "checked" => false,
            "disabled" => false}},
        {"indicator" => {
            "checked" => true,
            "disabled" => true}},
        {"barcode" => {
            "checked" => false,
            "disabled" => false}},
        {"location" => {
            "checked" => false,
            "disabled" => false}},
        {"location_barcode" => {
            "checked" => false,
            "disabled" => false}}
    ]


#### Label sizes for container_management_labels plugin.
Label keys should match those used in the `en.yml` file in the plugin and should define a 
page size and margin.

    AppConfig[:container_management_labels_pagesize] = {
        "dymo-30256" => {
            "size" => "59mm 102mm",
            "margin" => "5mm 1mm 5mm 1mm"},
        "avery-5163" => {
            "size" => "letter",
            "margin" => "0.5in 0.125in"}
    }
    
If no label sizes are defined, the plugin will default to a letter size with 0.25in margins 
(defined in `plugin_init.rb`). The keys should be named the same as in the CSS and the translation 
yml (below).

#### Autoscaling can also be turned on or off from the config file.
Autoscaling attempts to scale any label that overflows the defined label area by applying a 
css transform. If "disabled" is set to false, an end user can turn autoscaling on or off on a 
per use basis.

    AppConfig[:container_management_labels_autoscale] = {
      "checked" => true,
      "disabled" => false
    }

#### Printing Files (and other sub container labels) can also be turned on or off from the config file.
Allows the user to print files (or other subcontainer labels). This will print labels for all
subcontainers associated with the top containers selected or may be filtered to only
archival objects whose level is set by the list below.
If "disabled" is set to false, an end user can turn printing files on or off on a per use basis.

    AppConfig[:container_management_labels_print_files] = {
      "checked" => true,
      "disabled" => false
    }
    
#### Printing Files (and other sub container labels) can also be set to only print specific levels.
Set this array to include the value of the archival object level that you want to print subcontainer
labels for. Acceptable values are 
```
["class", "collection", "file", "fonds", "item", 
"otherlevel", "recordgrp", "series", "subfonds", 
"subgrp", "subseries"]
 ```  
To set it to print file level labels only:

    AppConfig[:container_management_labels_print_levels] = ["file"]
    
### /frontend/assets/container_labels.css

This is where the CSS is defined for the label fields and for the specific layouts. Note the convention
of using the label name as a namespace, eg ".dymo-30256". Also note that specific field css must use the same namespace as
fields listed in `AppConfig[:container_management_labels]`, eg a class of ".indicator".
      
#### /locales/en.yml

The translations for each label are defined here. Note the hyphen in the label name.

    en:
      top_container_labels:
          _frontend:
            labels:
              label_type_dymo-30256: Dymo-30256

## Fields/Data Displayed

The labels will display the following fields 
(if data is present and the fields are set to display in 
`AppConfig['container_management_labels']`):

    Insititution Name
    Repository name
    Resource ID (a concatenated list of all resource ids associated with the top container)
    Resource Title (a concatenated list of all resource titles associated with the top container)
    Agent Name (a concatenated list of all creators associated with the top container's associated resource)
    Series ID (a concatenated list of all series associated with the top container)
    Top Container Indicator
    Top Container Barcode
    Location Title
    Location Area
    Location Barcode

## Barcodes

Barcodes can be turned off by omitting both of the barcode keys in 
`AppConfig[::container_management_labels]` I.E. omit the entries for `barcode` and 
`location_barcode`

The barcodes are generated using the jQuery barcode plugin from http://barcode-coder.com/en/barcode-jquery-plugin-201.html
The following barcode types are available - codabar is the default type:

    codabar (Codabar - numeric, typically used in libraries)
    code11 (Code 11 - numeric, typically used in telecom)
    code39 (Code 39 - alpha-numeric, general purpose)
    code93 (Code 93 - alpha-numeric, compact general purpose)
    code128 (Code 128 - alpha-numeric, general purpose)
    ean8 (EAN 8 - numeric, compressed EAN)
    ean13 (EAN 13 - numeric, European Article Numbering)
    std25 (Standard 2 of 5/Industrial 2 of 5 - numeric, not in common use)
    int25 (Interleaved 2 of 5 - compact numeric, typically used in industry)
    msi (MSI - numeric, Plessey code variation)
    datamatrix (DataMatrix, ASCII + extended - alpha-numeric, 2D for small, high density use)

Note that the use of the datamatrix type barcode will most likely require some reworking of the css.