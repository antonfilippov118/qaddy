class Session < ActiveRecord::SessionStore::Session
  def self.find_by_session_id(session_id)
    find(:first,:conditions => ["session_id = ?",session_id])
  end

  def user
    user_id = self.data["userid"]
    User.find(user_id) if user_id
  end

end
