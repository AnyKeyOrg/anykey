module RateLimitable
    private 

    def limit_create_request(base_key, redirection_path, limit = 9)
        client_ip = request.remote_ip

        rate_limit_key = "#{base_key}_rate_limit:#{client_ip}"
        rate_limit_count = Rails.cache.read(rate_limit_key).to_i
    
        if rate_limit_count >= limit
          flash[:alert] = "Rate limit exceeded. Please try again later."
          redirect_to redirection_path
        end
  
        Rails.cache.write(rate_limit_key, rate_limit_count + 1, expires_in: 60.seconds)
    end

end
