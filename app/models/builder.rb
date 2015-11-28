class Builder < ActiveRecord::Base
  has_many :builds
  belongs_to :architecture

  def busy
    return false if self.builds.count == 0
    return true if self.builds.order('id desc').first.active == true
    return false
  end
end
