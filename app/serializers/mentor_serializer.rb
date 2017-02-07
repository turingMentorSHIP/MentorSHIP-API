class MentorSerializer < ActiveModel::Serializer
  attributes :id,
             :avatar,
             :name,
             :email,
             :phone_number,
             :slack_username,
             :location,
             :mentor_timezone_id,
             :bio,
             :expertise,
             :company,
             :position,
             :last_active

  def last_active
    object.last_active.strftime("%A %d %b %Y %l:%M %p")
  end
end
