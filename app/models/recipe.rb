class Recipe < ActiveRecord::Base
  has_many :packages
  has_many :builds
  has_many :architectures, through: :packages

  def self.search(search)
    if search
      # TODO: Better sort version numbers as they are strings
      where('name LIKE ?', "%#{search.downcase}%").order([:category, :name, :version])
    else
      all.order([:category, :name, :version])
    end
  end

  def to_param
    #"#{name}-#{version.parameterize("_")}"
    "#{name}-#{version}"
  end
end
