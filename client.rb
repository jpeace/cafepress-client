require './connection'
require './cookies'
require './hidden_fields'

module CafePress
  
  class ClientAction
    attr_accessor :uri
    attr_reader :response, :hidden
        
    def update(response)
      @response = response
      @hidden = HiddenFields.new(response.body)
    end
  end
  
  class Client

    attr_reader :last_action
    
    def initialize
      @last_action = ClientAction.new
      clear_session
    end
    
    def clear_session
      @cookies = Cookies.new
      self.get! 'https://members.cafepress.com/login.aspx', :include_cookies => false
    end
    
    def login(email, pass)
      self.post! 'https://members.cafepress.com/login.aspx', {'txtEmail'=>email, 'txtPassword'=>pass}
    end
    
    def add_image_folder(name)
      self.post! 'http://members.cafepress.com/imagebasket/folders_manage.aspx', 
                        {'txtNewFolder'=>name}, :clicked => 'btnAddFolder'
    end
    
    def get!(url, args={})
      self.exec_request(:get, url, args)
    end
    
    def post!(url, form, args={})
      get! url
      args[:form] = form.merge(@last_action.hidden.tokens)
      self.exec_request(:post, url, args)
    end
    
    def exec_request(verb, url, args={})
      redirects = args[:redirects] || 0
      include_cookies = args[:include_cookies] || true
      
      form = args[:form] || {}
      form.merge!({'__EVENTTARGET'=>args[:clicked]}) unless args[:clicked].nil?
      
      puts "#{verb.to_s.upcase} #{url}"
      
      conn = Connection.new(url)
      @last_action.uri = conn.uri
      http = conn.build_http
      request = verb == :get ? conn.build_get_request : conn.build_post_request(form)
      request['cookie'] = @cookies.to_s if include_cookies
      handle_response(http.request(request), redirects)
    end
    
    def handle_response(response, redirects=0)
      raise 'Too many redirects' if redirects > 10
      
      @cookies.update(response['set-cookie'])
      
      if (response.code == '302')
        location = response['location']
        location = "#{@last_action.uri.scheme}://#{@last_action.uri.host}#{location}" if location[0]=='/'
        get! location, :redirects => redirects + 1
      else
        @last_action.update(response)
      end
    end
    
  end
end