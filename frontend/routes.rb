ArchivesSpace::Application.routes.draw do
  match('/plugins/dartmouth_top_containers/bulk_operations/print_labels' => 'dartmouth_top_containers#print_labels', :via => [:post])
end
