class View < Portfolio::App
  get '/sender/:token' do
    @token = params[:token]
    erb :sender
  end
end
