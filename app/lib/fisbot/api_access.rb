# frozen_string_literal: true

class ApiAccess
  URL = ENV['FISBOT_API_URL']
  KEY = ENV['FISBOT_CLIENT_REGISTRATION_ID']

  def initialize(resource)
    @resource = resource
  end

  def resource_uri(path = nil, query = {})
    path = "/#{path}" if path
    query[:api_key] = KEY
    URI("#{api_url}/#{@resource}#{path}.json?#{query.to_query}")
  end

  class << self
    def fis_public_url
      ENV['FISBOT_PUBLIC_URL'].presence || ENV['FISBOT_API_URL']
    end
  end

  private

  def api_url
    "#{URL}/api/v1"
  end
end
