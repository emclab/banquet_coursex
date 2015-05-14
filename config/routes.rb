BanquetCoursex::Engine.routes.draw do
  resources :courses do
    collection do
      get :search
      get :search_results
      get :autocomplete
    end  
  end
  
  root :to => 'courses#index'

end
