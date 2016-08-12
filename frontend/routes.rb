ArchivesSpace::Application.routes.draw do
  match('/plugins/top_containers_labels/print_labels' => 'top_containers_labels#print_labels', :via => [:post])
end
