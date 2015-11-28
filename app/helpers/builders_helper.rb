module BuildersHelper
  def heartbeat_info(builder)
    if !builder.lastheard
      return "New builder, no heartbeats"
    end

    age = Time.now.to_i - builder.lastheard.to_i
    if age < 90
      status = "<span style='font-weight: bold; color: #00ff00;'>Online</span>"
      if builder.busy
        state = "<span style='font-weight: bold; color: #00ffff;'>Working</span>"
      else
        state = "<span style='font-weight: bold; color: #cccccc;'>Idle</span>"
      end
      return "#{status}, #{state}"
    end
    return "<span style='font-weight: bold; color: #ffff00;'>Missing for #{time_ago_in_words(builder.lastheard)}</span>"
  end
end
