class DartmouthCommonIndexer < CommonIndexer

 
  add_indexer_initialize_hook do |indexer|

    indexer.add_document_prepare_hook {|doc, record|
      if record['record']['jsonmodel_type'] == 'top_container'
        doc['indicator_u_sstr'] = record['record']['indicator']
      end
    }
  end
end
