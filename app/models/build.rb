class Build < ActiveRecord::Base
  belongs_to :builder
  belongs_to :architecture
  belongs_to :recipe
end
