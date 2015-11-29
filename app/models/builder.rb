class Builder < ActiveRecord::Base
  has_many :builds
  belongs_to :architecture

  def last_build
    return nil if self.builds.count == 0
    return self.builds.order('id desc').first
  end

  def busy
    return false if self.builds.count == 0
    return (self.builds.order('id desc').first.active == true)
  end
end
