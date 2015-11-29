module BuildsHelper
  def build_state(build)
    if build.active == true
      return "<span style='font-weight: bold; color: #9999ff;'>Building...</span>"
    end

    if build.result == 0
      return "<span style='font-weight: bold; color: #00ff00;'>Successful</span>"
    end

    return "<span style='font-weight: bold; color: #ff0000;'>Failed</span>"
  end
end
