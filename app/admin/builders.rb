ActiveAdmin.register Builder.includes(:architectures) do
	index do
		column :hostname
		column :architecture
		column :owner
		column :location
		column "Last Seen", :lastheard
		actions
	end

	permit_params :hostname, :architecture_id, :owner, :location, :lastheard

	filter :architecture
	filter :owner
	filter :location
end
