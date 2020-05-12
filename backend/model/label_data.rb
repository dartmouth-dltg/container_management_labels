require 'aspace_logger'
class LabelData

  include JSONModel

  attr_accessor :labels

  def initialize(uris)
    @uris = uris
    @labels = build_label_data_short
  end

  def build_label_data_short

    ids = @uris.map {|uri| JSONModel(:top_container).id_for(uri)}
    
    # Eagerly load all of the Top Containers we'll be working with
    load_top_containers(ids)

    labels = []
    
    # create a label for each top container
    ids.each do |top_container_id|
      tc = fetch_top_container(top_container_id)
      agent = agent_for_top_container(tc)
      area, location, location_barcode = location_for_top_container(tc)
      resource_id, resource_title = resource_for_top_container(tc)
      institution, repository = institution_repo_for_top_container(tc)

      labels << tc.merge({
                  "agent_name" => agent,
                  "area" => area,
                  "location" => location,
                  "location_barcode" => location_barcode,
                  "resource_id" => resource_id,
                  "resource_title" => resource_title,
                  "institution_name" => institution,
                  "repository_name" => repository,
                  })
    end
    
    labels
  end


  private
  
  # returns an agent name if a creator exists for the colelction linked to the top container
  def agent_for_top_container(tc)
    agent_names = []
    # resolve the linked agents
    URIResolver.resolve_references(tc['collection'],['linked_agents'])
    
    #find the first creator and set the name if there is one
    agent_ref = tc['collection'][0]['_resolved']['linked_agents'].select{|a| a['role'] == 'creator'}
    agent_ref.each do |agent|
      agent_names << agent['_resolved']['title']
    end
    
    agent_name = agent_names.compact.join("; ")
    
    agent_name
  end
  
  # returns a location and location barcode for a top container
  def location_for_top_container(tc)

    tc_loc = tc['container_locations'].select { |cl| cl['status'] == 'current' }.first
    loc = tc_loc ? tc_loc['_resolved'] : {}
    area = loc['area'] ? loc['area'] : ''
    location = ['coordinate_1_indicator', 'coordinate_2_indicator', 'coordinate_3_indicator'].map {|fld| loc[fld]}.compact.join(' ')
    location_barcode = loc['barcode'] ? loc['barcode'] : ''

    return area, location, location_barcode        
  end
  
  # returns two semicolon concatenated lists of all resource title and resource ids inked to the top container
  def resource_for_top_container(tc)
    resource_ids = []
    resource_titles = []
    
    resources = tc['collection'].empty? ? {} : tc['collection']
    resources.each do |res|
      resource_ids << res['identifier']
      resource_titles << res['display_string']
    end
    resource_id = resource_ids.compact.join("; ")
    resource_title = resource_titles.compact.join("; ")

    return resource_id, resource_title
  end
  
  def institution_repo_for_top_container(tc)
    institution =  tc['repository']['_resolved']['parent_institution_name'] ? tc['repository']['_resolved']['parent_institution_name'] : ''
    repository = tc['repository']['_resolved']['name']
    
    return institution, repository
  end
  
  def load_top_containers(ids)
    top_container_list = TopContainer.filter(:id => ids).all
    top_container_json_records = Hash[TopContainer.sequel_to_jsonmodel(top_container_list).map {|tc| [tc.id, tc.to_hash(:trusted)]}]

    @top_container_json_records = URIResolver.resolve_references(top_container_json_records, ['container_locations','repository','collection'])
  end

  def fetch_top_container(id)
    @top_container_json_records.fetch(id)
  end


end
