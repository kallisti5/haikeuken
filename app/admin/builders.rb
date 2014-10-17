ActiveAdmin.register Builder.includes(:architectures) do
	scope :all, :default => true
end
