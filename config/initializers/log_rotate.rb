# rename logfile if
env = Rails.env
today = Date.today.strftime '%Y%m%d'

backup_log = "log/#{today}.#{env}.log"
current_log = "log/#{env}.log"

if File.exist?(current_log) && !File.exist?(backup_log)
  FileUtils.mv current_log, backup_log
end

