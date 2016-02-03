class LabelData

  include JSONModel
  
  attr_accessor :labels

  def initialize(uris)
    @uris = uris
    @labels = build_label_data
  end


  def build_label_data
    ids = @uris.map {|uri| JSONModel(:top_container).id_for(uri)}

    # Pre-store the links between our top containers and the archival objects they link to
    top_container_to_ao_links = calculate_top_container_linkages(ids)

    # Eagerly load all of the AO and Top Containers we'll be working with
    load_top_containers(top_container_to_ao_links.keys)
    load_archival_objects(top_container_to_ao_links.values.flatten.uniq)

    # Finally, walk over our AO/top container pairs and create a label for each
    labels = []
    top_container_to_ao_links.each do |top_container_id, ao_ids|
      ao_ids.each do |ao_id|
        ao = fetch_archival_object(ao_id)
        tc = fetch_top_container(top_container_id)
        series = series_title_for(ao_id)

        labels << tc.merge({'archival_object' => {'ref' => ao['uri'], 'series' => series, '_resolved' => ao}})
      end
    end

    labels
  end


  private

  # Returns a hash like {123 => 456}, meaning "Top Container 123 links to Archival Object 456"
  # Only includes the links to Archival Object box records
  def calculate_top_container_linkages(ids)
    result = {}

    TopContainer.linked_instance_ds.
      join(:archival_object, :id => :instance__archival_object_id).
      filter(:top_container__id => ids).
      filter(:archival_object__other_level => 'box').
      select(Sequel.as(:archival_object__id, :ao_id),
             Sequel.as(:top_container__id, :top_container_id)).each do |row|

      result[row[:top_container_id]] ||= []
      result[row[:top_container_id]] << row[:ao_id]
    end

    result
  end


  def load_archival_objects(ids)
    ao_list = ArchivalObject.filter(:id => ids).all

    # Our JSONModel(:archival_object) records (keyed on ID)
    @ao_json_records = Hash[ArchivalObject.sequel_to_jsonmodel(ao_list).map {|ao| [ao.id, ao.to_hash(:trusted)]}]

    # And their series display strings
    @ao_series_titles = Hash[ao_list.map {|ao| [ao.id, TopContainer.find_title_for(ao.series || ao)]}]
  end


  def load_top_containers(ids)
    top_container_list = TopContainer.filter(:id => ids).all
    top_container_json_records = Hash[TopContainer.sequel_to_jsonmodel(top_container_list).map {|tc| [tc.id, tc.to_hash(:trusted)]}]

    @top_container_json_records = URIResolver.resolve_references(top_container_json_records, ['container_locations'], {})
  end


  def series_title_for(ao_id)
    @ao_series_titles.fetch(ao_id)
  end


  def fetch_top_container(id)
    @top_container_json_records.fetch(id)
  end


  def fetch_archival_object(id)
    @ao_json_records.fetch(id)
  end

end
