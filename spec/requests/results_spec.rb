require 'rails_helper'

RSpec.describe "Results", type: :request do
  describe "Results Controller" do

    context 'When user hits api to get results' do

      before(:each, specific_specs: true) do
        post '/results_data', params:  {"result": {"subject": "Demo", "timestamp": "2023-03-05 19:47:27.678", "marks": 181}}
      end

      it 'Display the results' do
        get '/results'
        resp = JSON.parse(response.body)
        expect(resp['results'].count).to eq(0)
      end


      it 'Expect the result count should be 1', specific_specs: true do
        get '/results'
        resp = JSON.parse(response.body)
        expect(resp['results'].count).to eq(1)
        expect(resp['results'].first['subject']).to eq('Demo')
      end


      it 'Display daily results stats' , specific_specs: true do
        get '/daily_result_stats'
        expect(response.code).to eq('200')
      end

      it 'Display Monthly results stats' , specific_specs: true do
        get '/monthly_result_stat'
        expect(response.code).to eq('200')
      end
    end


    context 'Exception test for Result controller' do

      it 'Should fail while creating result' do
        post '/results_data', params:   {"subject": "Demo", "timestamp": "2023-03-05 19:47:27.678", "marks": 181}
        resp = JSON.parse(response.body)
        expect(resp['status']).to eq(500)
      end
    end
  end
end
