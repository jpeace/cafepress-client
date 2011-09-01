module CafePress

  class Cookies

    attr_reader :hash
    
    def initialize(header='')
      cookies = header.split(/path=\/(; HttpOnly)?,/)
      cookies = cookies.map {|x| x.split(';')[0].strip() }
      cookies = cookies.select {|x| x != ''}  

      @hash = {};
      cookies.each { |x| 
        rx = /(\S+)=(\S+)/
        k = x[rx,1]
        v = x[rx,2]
        @hash[k]=v
      }
    end
    
    def update(header)
      new = Cookies.new(header)
      @hash.merge!(new.hash)
    end

    def to_s
      array = @hash.map {|x| "#{x[0]}=#{x[1]}"}
      return array.join(';')
    end

  end
  
end