class ArchivesSpaceService < Sinatra::Base

  Endpoint.post('/repositories/:repo_id/dartmouth_top_containers/bulk/labels')
  .description("Bulk label data")
  .params(["record_uris", [String], "A list of container uris"],
          ["repo_id", :repo_id])
  .permissions([])
  .returns([200, "Container data for label printing"]) \
  do
    label_data = LabelData.new(params[:record_uris])
    json_response(label_data.labels)
  end

end
