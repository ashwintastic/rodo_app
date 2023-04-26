Rails.application.routes.draw do
  post :results_data, to: 'results#create'
  get :results, to: 'results#index'
  get :daily_result_stats, to: 'results#fetch_daily_stats'
  get :monthly_result_stat, to: 'results#fetch_monthly_stats'
end
