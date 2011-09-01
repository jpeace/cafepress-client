require 'uri'
require 'net/http'
require 'net/https'

module CafePress
  
  class Connection

    attr_reader :uri
    
    def initialize(uri)
      @uri = URI.parse(uri)
    end

    def build_http
      http = Net::HTTP.new(@uri.host, @uri.port)
      if (@uri.port == 443)
        http.use_ssl = true
      end
      return http
    end

    def build_get_request
      return Net::HTTP::Get.new(@uri.request_uri)
    end

    def build_post_request(form)
      request = Net::HTTP::Post.new(@uri.request_uri)
      request.set_form_data(form) unless form.nil?
      return request
    end

  end
  
end