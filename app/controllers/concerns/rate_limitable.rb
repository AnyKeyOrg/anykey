module RateLimitable
    private 

    CACHE_KEY_PATTERN = '%{type}:%{base_key}:%{identifier}'.freeze

    def limit_request_by_ip(base_key, redirection_path, limit = 9, expiry = 60)
      client_ip = request.remote_ip
      rate_limit_key = CACHE_KEY_PATTERN % {type: "ip_rate_limit", base_key: base_key, identifier: client_ip}
      rate_limit_count = Rails.cache.read(rate_limit_count).to_i
    end 

    def limit_request_by_signature(base_key, redirection_path, limit = 9, expiry = 60)
      device_signature = generate_device_signature(request)
      rate_limit_key = CACHE_KEY_PATTERN % { type: 'device_rate_limit', base_key: base_key, identifier: device_signature }
      rate_limit_count = Rails.cache.read(rate_limit_key).to_i
  
      process_rate_limit(rate_limit_key, rate_limit_count, limit, expiry, redirection_path)
    end

    def generate_device_signature(request)
      user_agent = request.user_agent || ""
      accept_language = request.env['HTTP_ACCEPT_LANGUAGE'] || ""
      Digest::SHA1.hexdigest([request.remote_ip, user_agent, accept_language].join(':')) # unique device signature
    end

    def process_rate_limit(key, current_count, limit, expiry, redirect_path)
      if current_count >= limit
        ahoy.track "Rate limit exceeded", key: key
        flash[:alert] = 'Rate limit exceeded. Please try again later.'
        redirect_to redirect_path
        return false
      else
        Rails.cache.write(key, current_count + 1, expires_in: expiry.seconds)
        return true
      end
    end
end
