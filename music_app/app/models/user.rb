class User < ApplicationRecord
    validates :email, :session_token, presence: true, uniqueness: true
    validates :password_digest, presence: true
    validates :password, length: {minimum: 6}, allow_nil: true

    attr_reader :password

    after_initialize :ensure_session_token

    def ensure_session_token
        # if the session token is nil, generate a new one
        self.session_token ||= SecureRandom::urlsafe_base64
    end

    def self.generate_session_token
        # generates the session token using random base64 string
        self.session_token = SecureRandom::urlsafe_base64
    end

    def reset_session_token!
        # regenerate the session token to a new value, then save and return it
        self.session_token = SecureRandom::urlsafe_base64
        self.save!
        self.session_token
    end

    def password=(password)
        # sets the @password ivar to the input, the creates a new digest of the input pw
        @password = password
        self.password_digest = BCrypt::Password.create(self.password)
    end

    def is_password?(password)
        # translates the password digest back to see if the stored pw is the same as the given pw
        password_test = BCrypt::Password.new(self.password_digest)
        password_test.is_password?(password) 
    end

    def self.find_by_credentials(target_email, password)
        # find a specific user by email
        user = User.find_by(email: target_email)

        # filter out users that don't also have a matching password (or have not been found)
        return nil if user.nil?
        if user && user.is_password?(password)
            return user
        else
            return nil
        end
    end

end