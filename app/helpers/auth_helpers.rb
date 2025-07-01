module AuthHelpers
  def current_user(unauthorized = true)
    user_id = fetch_user_account_id(token)
    User.find(user_id)
  rescue StandardError => e
    Rails.logger.error("Auth error: #{e.message}")
    if unauthorized
      unauthorized_error!
    else
      nil
    end
  end

  def token
    auth = headers['Authorization'].to_s
    # Debug logging to identify token extraction issues
    Rails.logger.info("Auth header: #{auth}")
    # Extract token after 'Bearer '
    received_token = auth.start_with?('Bearer ') ? auth.split('Bearer ').last : auth.split.last
    Rails.logger.info("Extracted token: #{received_token&.first(10)}...")
    received_token
  end

  def fetch_user_account_id(token)
    return if token.blank?

    begin
      jwt_token = JWT.decode(token, ENV.fetch('SECRET_KEY_BASE', nil)).first
      Rails.logger.info("JWT decoded: #{jwt_token['sub']}")
      jwt_blacklist = JwtDenylist.find_by(jti: jwt_token['jti'])
      jwt_token['sub'].to_i unless jwt_token.nil? || jwt_blacklist.present?
    rescue JWT::ExpiredSignature
      Rails.logger.error("JWT expired signature")
      nil
    rescue JWT::VerificationError
      Rails.logger.error("JWT verification error")
      nil
    rescue JWT::DecodeError => e
      Rails.logger.error("JWT decode error: #{e.message}")
      nil
    end
  end

  def unauthorized_error!
    error!('401 Unauthorized', 401)
  end
end
