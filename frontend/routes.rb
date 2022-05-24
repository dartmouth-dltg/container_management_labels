ArchivesSpace::Application.routes.draw do
  [AppConfig[:frontend_proxy_prefix], AppConfig[:frontend_prefix]].uniq.each do |prefix|
    scope prefix do
      match('plugins/top_containers_labels/print_labels' => 'top_containers_labels#print_labels', :via => [:post])
    end
  end
end
