class EmployeesController < ApplicationController
  def show
    @employee_id = params[:id]
    @individual_data = individual_data
  end

  private

  def individual_data 
    url = 'https://sandbox.tryfinch.com/api/employer/individual'
    headers = { 
      "Authorization" => "Bearer #{token}",
      "Content-Type" => 'application/json',
    }
      
    response = HTTParty.post(url, body: data.to_json, headers: headers)
    response
  end

  def data
    {
      requests: [
          {
              individual_id: "#{params[:id]}"
          }
      ]
    }
  end

  def token
    token = Rails.cache.fetch("#{params[:provider_id]}/access_token", expires_in: 24.hours) do
      new_token
    end

    token
  end

  def new_token
    url = 'https://sandbox.tryfinch.com/api/sandbox/create'
    headers = { 'Content-Type' => 'application/json' }

    response = HTTParty.post(url, body: provider_params.to_json, headers: headers)
    response["access_token"]
  end

  def provider_params
    {
      provider_id: params[:id],
      products: ["company", "directory", "individual", "employment", "payment", "pay_statement"],
      employee_size: 10
    }
  end
end
