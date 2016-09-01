require 'uri'

class TopContainersLabelsController < TopContainersController

  set_access_control  "view_repository" => [:show, :typeahead, :bulk_operations_browse, :print_labels]
 
  def print_labels
    post_uri = "/repositories/#{session[:repo_id]}/top_containers_labels/print_labels"

    response = JSONModel::HTTP.post_form(URI(post_uri), {"record_uris[]" => Array(params[:record_uris])})

    results = ASUtils.json_parse(response.body)

    if response.code =~ /^4/
      return render_aspace_partial :partial => 'top_containers/bulk_operations/error_messages', :locals => {:exceptions => results, :jsonmodel => "top_container"}, :status => 500
    end

    render_aspace_partial :partial => "labels/bulk_action_labels", :locals => {:labels => results}
  end

  def bulk_operation_search
    super
  end
end

