ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    #div class: "blank_slate_container", id: "dashboard_default_message" do
    #  span class: "blank_slate" do
    #    span I18n.t("active_admin.dashboard_welcome.welcome")
    #    small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #  end
    #end
    columns do
		column do
			panel "Statistics" do
				statistics = [
					{:metric => "Recipes", :value => Recipe.count},
					{:metric => "Broken Recipes", :value => Recipe.where("lintret > 0").count},
					{:metric => "Packages", :value => Package.where("latestrev > 0").count},
					{:metric => "Missing Packages", :value => Package.where("latestrev = 0").count},
				]

				table_for statistics do
					column "Metric", :metric
					column "Value", :value
				end
			end
		end
		column do
			panel "Last seen builders" do
				table_for Builder.order("lastheard desc").limit(5) do |system|
					column :hostname
					column :owner
					column "Last seen", :lastheard
				end
			end
		end
	end

    columns do
      column do
        panel "Builders" do
          table_for Builder.all do
            column "Hostname", :hostname
	        column "Architecture", :architecture
	        column "Location", :location
	        column "Owner", :owner
          end
        end
      end
    end
  end # content
end
