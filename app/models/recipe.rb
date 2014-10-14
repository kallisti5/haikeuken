class Recipe < ActiveRecord::Base
  has_many :packages
  has_many :architectures, through: :packages
  has_many :builds

  def self.search(search)
    if search
      # TODO: Better sort version numbers as they are strings
      where("name LIKE ?", "%#{search}%").order(:version)
    else
      all
    end
  end
end
