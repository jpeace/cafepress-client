class CookieHelper
  
  def header_to_hash(header)
    cookies = header.split(/path=\/(; HttpOnly)?,/)
    cookies = cookies.map {|x| x.split(';')[0].strip() }
    cookies = cookies.select {|x| x != ''}  
    
    hash = {};
    cookies.each { |x| 
      rx = /(\S+)=(\S+)/
      k = x[rx,1]
      v = x[rx,2]
      hash[k]=v
    }
    
    return hash
  end
  
  def hash_to_header(hash)
    array = hash.map {|x| "#{x[0]}=#{x[1]}"}
    return array.join(';')
  end
  
end