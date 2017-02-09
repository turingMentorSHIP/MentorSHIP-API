class CensusProfile

  def initialize(user_hash)
    @slack = user_hash[:slack]
    @email = user_hash[:email]
    @first_name = user_hash[:first_name]
    @last_name = user_hash[:last_name]
    @id = user_hash[:id]
    @avatar = user_hash[:avatar]
    @cohort = user_hash[:cohort]
  end

  def self.find(id, token)
    user_hash = CensusService.new(id).get_user(token)
    CensusProfile.new(user_hash)
  end

end