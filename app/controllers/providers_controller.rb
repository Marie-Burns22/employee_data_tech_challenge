class ProvidersController < ApplicationController

  def index
    @providers = [
      { name: "ADP Run", id: 'adp_run' },
      { name: "Gusto", id: 'gusto' }
    ]
  end

  def show
    @provider_id = params[:id]
    @employees = directory
  end

  private 

  def token
    token = Rails.cache.fetch("#{params[:id]}/access_token", expires_in: 24.hours) do
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

  def directory
    url = 'https://sandbox.tryfinch.com/api/employer/directory'
    headers = { 
      "Authorization" => "Bearer #{token}",
      "Content-Type" => "application/json",
    }

    response = HTTParty.get(url, headers: headers)
    response.parsed_response['individuals']
  end
end