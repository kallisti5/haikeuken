module ApplicationHelper
  def package_icon(package, size = 16)
    if !package
      tooltip = { :toggle => "tooltip", :placement => placement, :title => "Scanning..." }
      return image_tag "icons/working-bar.gif", :data => tooltip
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

  def lint_icon(recipe, size = 16)
    placement = (size == 16) ? "left" : "bottom"
    if !recipe || !recipe['lintret']
      tooltip = { :toggle => "tooltip", :placement => placement, :title => "No lint available" }
      return image_tag "fc#{size}/emotion_question.png", :data => tooltip
    end
    if recipe['lintret'] == 0
      tooltip = { :toggle => "tooltip", :placement => placement, :title => "Problems found" }
      return image_tag "fc#{size}/exclamation.png", :data => tooltip
    else
      tooltip = { :toggle => "tooltip", :placement => placement, :title => "No problems found" }
      return image_tag "fc#{size}/accept_button.png", :data => tooltip
    end
  end
end
