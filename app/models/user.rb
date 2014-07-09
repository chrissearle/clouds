class User < ActiveRecord::Base
  has_many :authentications
  has_many :points

  def self.get_user(user_id)
    begin
      User.find(user_id)
    rescue ActiveRecord::RecordNotFound
      logger.warn "User #{user_id} requested but not found"
    end
  end
end
