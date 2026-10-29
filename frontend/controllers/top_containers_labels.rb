require 'uri'

class TopContainersLabelsController < ApplicationController

  set_access_control  "view_repository" => [:print_labels]

  def print_labels
    endpoint = params[:print_files] ? "print_sub_labels" : "print_labels"
    post_uri = "/repositories/#{session[:repo_id]}/top_containers_labels/#{endpoint}"

    response = JSONModel::HTTP.post_form(URI(post_uri), {"record_uris[]" => Array(params[:record_uris])})

    unless response.code.start_with?("2")
      return render_aspace_partial :partial => 'top_containers/bulk_operations/error_messages', :locals => {:exceptions => error_for(response), :jsonmodel => "top_container"}, :status => 500
    end

    render_aspace_partial :partial => "labels/bulk_action_labels", :locals => {:labels => ASUtils.json_parse(response.body)}
  end

  private

  # The error partial iterates hash errors per attribute; anything else (404
  # message, 5xx, non-json body) is passed as a plain string.
  def error_for(response)
    body = ASUtils.json_parse(response.body)
    return body if body.is_a?(Hash) && body["error"].is_a?(Hash)

    (body.is_a?(Hash) && body["error"]) || response.body
  rescue JSON::ParserError
    response.body
  end
end
