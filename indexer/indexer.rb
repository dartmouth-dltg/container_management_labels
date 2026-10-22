# Index top container indicators into indicator_u_stext for the indicator search
# added to the top container bulk operations. Core only indexes indicator_u_icusort.
# The values match those written by the box_search plugin, so the two can be loaded together.
class IndexerCommon

  add_indexer_initialize_hook do |indexer|
    indexer.add_document_prepare_hook {|doc, record|
      if record['record']['jsonmodel_type'] == 'top_container'
        doc['indicator_u_stext'] = IndexerCommon.container_labels_indicator_variants(record['record']['indicator'])
      end
    }
  end

  # the indicator as entered, with punctuation as spaces, with punctuation and
  # spaces removed, and split between numbers and letters ("1A" => "1 A")
  def self.container_labels_indicator_variants(indicator)
    return [] if indicator.nil?

    [
      indicator,
      indicator.gsub(/[[:punct:]]+/, " "),
      indicator.gsub(/[[:punct:] ]+/, ""),
      indicator.scan(/([0-9]+|[^0-9]+)/).flatten(1).join(" ")
    ].uniq
  end

end
