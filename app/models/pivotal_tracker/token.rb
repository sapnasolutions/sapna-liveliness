require 'hpricot'
require 'net/https'
require 'uri'

module PivotalTracker
  class Token
    
    def self.get_token(login, password)
      doc = parse_response(get_ssl_response(login, password))
      return doc.at('guid').innerHTML      
    rescue NoMethodError
      return nil
    end
    
  private
    def self.rest_uri
      URI.parse("https://www.pivotaltracker.com/services/v3/tokens/active")
    end
    
    def self.get_ssl_response(login, password)
      resource_uri = rest_uri
      http = https_new(rest_uri)      
      request = https_get(resource_uri, login, password)      
      response = http.request(request)
    end
    
    def self.https_new(uri)
      http = Net::HTTP.new(uri.host, uri.port) 
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      return http
    end
    
    def self.https_get(uri, login, password)
      request = Net::HTTP::Get.new(uri.request_uri)
      request.basic_auth(login, password)      
      return request
    end
    
    def self.parse_response(response)
      return Hpricot(response.body)
    end
    
  end
end