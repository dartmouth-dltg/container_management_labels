class LabelData
  include JSONModel
  
  attr_accessor :labels

  def initialize(uris)
    @uris = uris
    @labels = build_label_data
  end

  def build_label_data

    ids = @uris.map {|uri| JSONModel(:top_container).id_for(uri)}
    
    # Eagerly load all of the Top Containers we'll be working with
    load_top_containers(ids)

    labels = []
    
    # create a label for each top container
    ids.each do |top_container_id|
      labels << fetch_top_container(top_container_id)
    end

    labels
  end
  
  private

  def load_top_containers(ids)
    top_container_list = TopContainer.filter(:id => ids).all
    top_container_json_records = Hash[TopContainer.sequel_to_jsonmodel(top_container_list).map {|tc| [tc.id, tc.to_hash(:trusted)]}]

    @top_container_json_records = URIResolver.resolve_references(top_container_json_records, ['container_locations'], {})
  end

  def fetch_top_container(id)
    @top_container_json_records.fetch(id)
  end

end
