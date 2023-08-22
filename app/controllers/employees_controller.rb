class EmployeesController < ApplicationController

  CREATE_URL = 'https://sandbox.tryfinch.com/api/sandbox/create'
  EMPLOYMENT_DATA_URL = 'https://sandbox.tryfinch.com/api/employer/employment'
  INDIVIDUAL_DATA_URL = 'https://sandbox.tryfinch.com/api/employer/individual'

  def show
    @employee_id = params[:id]
    @provider_id = params[:provider_id]
    @individual_data = individual_data
    @employment_data = employment_data
  end

  private

  def individual_data    
    response = HTTParty.post(INDIVIDUAL_DATA_URL, body: request_body.to_json, headers: headers_with_token)
    
    if response.success?
      return response.parsed_response["responses"].first["body"]
    else
      return "Individual Data Not Available for #{params[:provider_id].titleize}. Error message: #{response.response.msg}"
    end
  end

  def employment_data 
    response = HTTParty.post(EMPLOYMENT_DATA_URL, body: request_body.to_json, headers: headers_with_token)

    if response.success?
      return response.parsed_response["responses"].first["body"]
    else
      return "Employment Data Not Available for #{params[:provider_id].titleize}. Error message: #{response.response.msg}"
    end
  end

  def request_body
    { requests: [{ individual_id: "#{params[:id]}" }] }
  end

  def headers_with_token
    { 
      "Authorization" => "Bearer #{token}",
      "Content-Type" => 'application/json',
    }
  end

  def token
    token = Rails.cache.fetch("#{params[:provider_id]}/access_token", expires_in: 24.hours) do
      new_token
    end

    token
  end

  def new_token
    headers = { 'Content-Type' => 'application/json' }

    response = HTTParty.post(CREATE_URL, body: provider_params.to_json, headers: headers)
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
