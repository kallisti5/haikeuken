ActiveAdmin.register Builder.includes(:architectures) do
	index do
		column :hostname
		column :architecture
		column :owner
		column :location
		column "Last Seen", :lastheard
		actions
	end

	filter :architecture
	filter :owner
	filter :location
end
