class User < ApplicationRecord
    attr_reader :password

    before_validation :ensure_session_token

    validates :email, :password_digest, :session_token, presence: true
    validates :email, :session_token, uniqueness: true
    validates :password, length: {minimum: 6, allow_nil: true }

    def self.find_by_credentials(email, password)
        @user = User.find_by(email: email)

        @user && @user.is_password?(password) ? @user : nil
    end

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def is_password?(password)
        BCrypt::Password.new(self.password_digest).is_password?(password)
    end

    def reset_session_token!
        self.session_token = generate_unique_session_token
        self.save!
        self.session_token
    end

    private

    def generate_unique_session_token
        loop do
            session_token = SecureRandom::urlsafe_base64
            return session_token unless User.exists?(session_token: session_token)
        end
    end

    def ensure_session_token
        self.session_token ||= generate_unique_session_token
    end
end
