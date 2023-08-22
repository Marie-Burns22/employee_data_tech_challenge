class ProvidersController < ApplicationController
  CREATE_URL = 'https://sandbox.tryfinch.com/api/sandbox/create'
  DIRECTORY_URL = 'https://sandbox.tryfinch.com/api/employer/directory'
  COMPANY_DATA_URL = 'https://sandbox.tryfinch.com/api/employer/company'
  
  def index
    @providers = [
      { name: "ADP Run", id: 'adp_run' },
      { name: "Bamboo HR", id: 'bamboo_hr' },
      { name: "Bamboo HR (API)", id: 'bamboo_hr_api' },
      { name: "HiBob", id: 'bob' },
      { name: "Gusto", id: 'gusto' },
      { name: "Humaans", id: 'humaans' },
      { name: "Insperity", id: 'insperity' },
      { name: "Justworks", id: 'justworks' },
      { name: "Namely", id: 'namely' },
      { name: "Paychex Flex", id: 'paychex_flex' },
      { name: "Paychex Flex (API)", id: 'paychex_flex_api' },
      { name: "Paycom", id: 'paycom' },
      { name: "Paycom (API)", id: 'paycom_api' },
      { name: "Paylocity", id: 'paylocity' },
      { name: "Paylocity (API)", id: 'paylocity_api' },
      { name: "Personio", id: 'personio' },
      { name: "Quickbooks", id: 'quickbooks' },
      { name: "Rippling", id: 'rippling' },
      { name: "Sage HR", id: 'sage_hr' },
      { name: "Sapling", id: 'sapling' },
      { name: "Squoia One", id: 'sequoia_one' },
      { name: "Square Payroll", id: 'square_payroll' },
      { name: "Trinet", id: 'trinet' },
      { name: "Trinet (API)", id: 'trinet_api' },
      { name: "Ulti Pro", id: 'ulti_pro' },
      { name: "Wave", id: 'wave' },
      { name: "Workday", id: 'workday' },
      { name: "Zenefits", id: 'zenefits' },
      { name: "Zenefits (API)", id: 'zenefits_api' }
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

  def headers_with_token
    { 
      "Authorization" => "Bearer #{token}",
      "Content-Type" => "application/json",
    }
  end
end