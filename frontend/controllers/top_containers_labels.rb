require 'uri'

class TopContainersLabelsController < TopContainersController

  set_access_control  "view_repository" => [:show, :typeahead, :bulk_operations_browse, :print_labels]

  def print_labels
    if params[:print_files]
      post_uri = "/repositories/#{session[:repo_id]}/top_containers_labels/print_sub_labels"
    else
      post_uri = "/repositories/#{session[:repo_id]}/top_containers_labels/print_labels"
    end

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

# add in the indicator range search
class TopContainersController

  private

  alias old_perform_search perform_search

  def perform_search
    unless params[:indicator].blank?
      if params[:q].blank?
        params[:q] = ""
      else
        params[:q] = "#{params[:q]} AND "
      end

      #convert the range into a set of indicators since indicators are defined as strings and we need exact matches
      if params[:indicator].downcase.include? "to"
        range = params[:indicator].split
          .find_all{|e| e[/\d+/]}
          .each{|e| e.gsub!(/\[|\]/,'').to_i}

        indicators = (range[0]..range[range.length-1]).step(1).to_a
      # otherwise just split the list up
      else
        indicators = params[:indicator].split
      end

      # then concatenate with the correct prefix and OR the search
      indicator_string = indicators.each { |e| e.prepend('indicator_u_stext:') }.join(" OR ")

      params[:q] << indicator_string
    end

    old_perform_search
  end
end
