# -*- coding: utf-8 -*-

module ImKayac
  def notify(database, username, fromUser)
    # とりあえず無認証決め打ち
    database.query("SELECT * FROM imkayac WHERE userId='#{database.escape("#{username}")}'").each do |r|
      uri = URI.parse("http://im.kayac.com/api/post/#{r["kayacId"]}")
      http = Net::HTTP.new(uri.host)
      http.post(uri.path, URI.escape("message=[OpenYo]\nYo from #{fromUser}"))
    end
  end
  module_function :notify
end
