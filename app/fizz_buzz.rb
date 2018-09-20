def humanized_time_ago(minutes)
    if minutes >=60
        "#{minutes/60} hours ago"
    else
        "#{minutes} minutes ago"
    end
end
humanized_time_ago(200)
