class ProvidersController < ApplicationController
  DIRECTORY_URL = 'https://sandbox.tryfinch.com/api/employer/directory'
  COMPANY_DATA_URL = 'https://sandbox.tryfinch.com/api/employer/company'

  def index
    @providers = [
      { name: "ADP Run", id: 'adp_run' },
      { name: "Gusto", id: 'gusto' }
    ]
  end

  def show
    @provider_id = params[:id]
    @employees = directory
    @company = company_data
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
    response = HTTParty.get(DIRECTORY_URL, headers: headers_with_token)

    if response.success?
      return response.parsed_response['individuals']
    else
      return "Directory not available for #{params[:id].titleize}. Error message: #{response.response.msg}"
    end
  end

  def company_data
    response = HTTParty.get(COMPANY_DATA_URL, headers: headers_with_token)

    if response.success?
      response.parsed_response
    else
      return "Company information not available for #{params[:id].titleize}. Error message: #{response.response.msg}"
    end
  end
      "Authorization" => "Bearer #{token}",
      "Content-Type" => "application/json",
    }

    response = HTTParty.get(url, headers: headers)
    response.parsed_response['individuals']
  end
end