require 'nexmo'
class MessagesController < ApplicationController

  def new
    Message.create!(:content => params[:text], :from => params[:msisdn])

    nexmo = Nexmo::Client.new(key: '5dc9c08c', secret: 'e2691853')

    nexmo.send_message(from: '12192099266', 
                       to: params[:msisdn], 
                       text: "You sent #{params[:text]}")

    head :ok, content_type: "text/html"
  end
end
