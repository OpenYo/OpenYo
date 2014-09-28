# -*- coding: utf-8 -*-

module GCM
  def notify(database, username, fromUser)
    database.query("SELECT * FROM GCMRegId WHERE userId='#{database.escape("#{username}")}'").each do |r|
      apiToken = getToken(database, r["project"])
      return false if apiToken.nil?
      uri = URI.parse("https://android.googleapis.com/gcm/send")
      http = Net::HTTP.new(uri.host)
      body = "[OpenYo]\nYo from #{fromUser}";
      param = "{\"registration_ids\": [\"#{r["regId"]}\"], \"data\": { \"message\": \"#{body}\" }}"
      header = { "Content-Type" => "application/json", "Authorization" => "key=#{apiToken}" }
      http.post(uri.path, param, header)
    end
  end
  def self.getToken(database, projNum)
    database.query("SELECT * FROM GCMApiToken WHERE project='#{database.escape("#{projNum}")}' LIMIT 1").each do |r|
      return r["token"] if not r["token"].nil?
    end
    # ここに来たらどうしよう？ assert?
  end
  module_function :notify
end
