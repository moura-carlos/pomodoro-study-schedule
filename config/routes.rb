Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :pomodoros, only: [:index, :export_csv]
  get 'pomodoros/export_csv', format: 'csv', to: 'pomodoros#export_csv', as: 'export_csv_pomodoro'
  root 'pomodoros#index'
end
