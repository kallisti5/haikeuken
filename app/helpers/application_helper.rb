module ApplicationHelper
  def package_icon(package, size = 16)
    if !package
      return image_tag "icons/working-bar.gif"
    else
      age = package.recipe.revision - package.latestrev
      hpkgname = "#{package.recipe['name']}-#{package.recipe['version']}-#{package.latestrev}-#{package.architecture['name']}.hpkg"
      repo = "#{package.repo['url']}/#{package.architecture['name']}/current/packages"
      placement = (size == 16) ? "left" : "bottom"

      if package.latestrev == 0
        tooltip = { :toggle => "tooltip", :placement => placement, :title => "No builds found" }
      elsif age == 0
        tooltip = { :toggle => "tooltip", :placement => placement, :title => "Up to date" }
      else
        tooltip = { :toggle => "tooltip", :placement => placement, :title => "#{age} #{'build'.pluralize(age)} behind" }
      end

      if package.latestrev == 0
        return image_tag "fc#{size}/box_none.png", :data => tooltip
      elsif age == 0
        return link_to image_tag("fc#{size}/box_green.png", :alt => package.latestrev, :data => tooltip), "#{repo}/#{hpkgname}"
      else
        return link_to image_tag("fc#{size}/box_old.png", :alt => package.latestrev, :data => tooltip), "#{repo}/#{hpkgname}"
      end
    end
  end
end
