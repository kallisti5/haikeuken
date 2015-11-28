module ApplicationHelper
  def package_icon(package, size = 16)
    if !package
      return image_tag "icons/working-bar.gif"
    else
      hpkgname = "#{package.recipe['name']}-#{package.recipe['version']}-#{package.latestrev}-#{package.architecture['name']}.hpkg"
      repo = "#{package.repo['url']}/#{package.architecture['name']}/current/packages"
      placement = (size == 16) ? "left" : "bottom"
      tooltip = { :toggle => "tooltip", :placement => placement, :title => (package.latestrev != 0 ? package.latestrev : "no builds") }
      if package.latestrev == 0
        return image_tag "fc#{size}/box_none.png", :data => tooltip
      elsif package.recipe.revision == package.latestrev
        return link_to image_tag("fc#{size}/box_green.png", :alt => package.latestrev, :data => tooltip), "#{repo}/#{hpkgname}"
      else
        return link_to image_tag("fc#{size}/box_old.png", :alt => package.latestrev, :data => tooltip), "#{repo}/#{hpkgname}"
      end
    end
  end
end
