# -*- coding: utf-8 -*-

module NotifyYo
  def notify(database, username, fromUser)
    # 誰から来たのかわからない。
    database.query("SELECT * FROM yoUser WHERE userId='#{database.escape("#{username}")}'").each do |r|
      uri = URI.parse("https://api.justyo.co/yo/")
      http = Net::HTTP.new(uri.host)
      http.post(uri.path, URI.escape("api_token=#{YOTOKEN}&username=#{r["yoId"]}"))
    end
  end
  module_function :notify
end
