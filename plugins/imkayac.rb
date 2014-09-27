# -*- coding: utf-8 -*-

require 'digest/sha1'

module ImKayac
  def notify(database, username, fromUser)
    database.query("SELECT * FROM imkayac WHERE userId='#{database.escape("#{username}")}'").each do |r|
      uri = URI.parse("http://im.kayac.com/api/post/#{r["kayacId"]}")
      http = Net::HTTP.new(uri.host)
      body = "[OpenYo]\nYo from #{fromUser}";
      param = "message=#{body}"
      if not r["password"].nil?
        param += "&password=#{r["password"]}"
      end
      if not r["seckey"].nil?
        param += "&sig=#{Digest::SHA1.hexdigest(body + r["seckey"])}"
      end
      http.post(uri.path, URI.escape(param))
    end
  end
  module_function :notify
end
