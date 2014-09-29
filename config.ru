require "./app.rb"
require "./view.rb"

map('/') { run Portfolio::App }
map('/views') { run View }
