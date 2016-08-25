Container Management Label Addon
================================

ArchivesSpace plugin to add the ability to print labels within the browser to ArchivesSpace.
It is compatible with ArchivesSpace v1.5.1+

This plugin was originally a fork of https://github.com/hudmol/container_management

## Installing

To install, just activate the plugin in your config.rb file by
including an entry such as:

     # If you have other plugins loaded, just add 'container_management_labels' to the list
     AppConfig[:plugins] = ['local', 'other_plugins', 'container_management_labels']
     
## Configuring & Modifying

The labels that are available to print from within the browser are defined in two (2) files and the config.rb file.

#### config.rb file

Define the fields and order in which they should appear on the label. The fields must be a member of the following list unless
additional fields are set in the model (backend/model/label_data.rb)

    institution_name
    repository_name
    resource_id
    resource_title
    agent_name
    series_id
    type
    indicator
    barcode
    location
    location_barcode
    
Each key should also indicate whether the field will be a default ("checked" => true) and whether the end user
should be able to change it ("disabled" => false). The following are the default settings and are set automatically if the
config file does not contain the :container_management_labels key.
    
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

Note that the indicator field should *always* be present and will *always* be set to "checked" and "disabled" during plugin initialization.
If it is not present in the :container_management_labels key it will be added at the end of the list.

Label sizes for container_management_labels plugin.
Label keys should match those used in the en.yml file in the plugin and should define a page size and margin.

    AppConfig[:container_management_labels_pagesize] = {
        "dymo-30256" => {"size" => "59mm 102mm", "margin" => "5mm 1mm 5mm 1mm"},
        "avery-5163" => {"size" => "letter", "margin" => "0.5in 0.125in"}
    }
    
If no label sizes are defined, the plugin will default to a letter size with 0.25 in margins (defined in plugin_init.rb).
The keys should be named the same as in the CSS and the locales (below).

Autoscaling can also be turned on or off from the config file.
Autoscaling attempts to scale any label that overflows the defined label area by applying a css transform.
If "disabled" is set to false, an end user can turn autoscaling on or off on a per job basis.

    AppConfig[:container_management_labels_autoscale] = {
      "checked" => true,
      "disabled" => false
    }

#### /frontend/assets/container_labels.css

     This is where the CSS is defined for the label fields and for the specific layouts. Note the convention
     of using the label name as a namespace, eg ".dymo-30256". Also note that specific field css must use the same namespace as
     fields listed in :container_management_labels, eg a class of ".indicator".
      
#### /locales/en.yml

    The translations for each label are defined here. Note the hyphen in the example.
        label_type_dymo-30256: Dymo-30256

## Fields/Data Displayed

The labels will display the following fields (if data is present):

    Insititution Name
    Repository name
    Resource ID (a concatenated list of all resource ids associated with the top container)
    Resource Title (a concatenated list of all resource titles associated with the top container)
    Agent Name (a concatenated list of all creators associated with the top container's associated resource)
    Series ID (a concatenated list of all series associated with the top container)
    Top Container Indicator
    Top Container Barcode
    Location Title
    Location Barcode

## Barcodes

The barcodes are generated using the jQuery barcode plugin from http://barcode-coder.com/en/barcode-jquery-plugin-201.html
The following barcode types are available and defaults to codabar:

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

## General Note

This plugin requires the container management integration in ArchivesSpace v1.5.1+.
It supports two label sizes on install:

    Dymo 30256 (59mm x 102mm, portrait, thermal roll)
    Avery 5163 (2in x 5in, letter, portrait)
    
Some local customization will be required to add additional label types and orientations. Additional css customizations may be necessary for
local browser and printer combinations.