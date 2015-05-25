require 'nexmo'
class MessagesController < ApplicationController

  def incoming
    if params[:text].present? and params[:msisdn].present?
      Message.create!(:content => params[:text], :from => params[:msisdn])

      nexmo = Nexmo::Client.new(key: '5dc9c08c', secret: 'e2691853')

      # http://stackoverflow.com/questions/546220/how-to-match-the-first-word-after-an-expression-with-regex
      # http://stackoverflow.com/questions/7124778/how-to-match-anything-up-until-this-sequence-of-characters-in-a-regular-expres

      # Capture everything until first occurance of 'from' or 'at' or the end of the sentence
      if match = params[:text].match(/(?<=\bwant\s|\border\s)(.+?)(?=\bfrom|$|\bat)/i)
        wants = match.captures.first || "nothing"
      end


      # Capture everything until first occurance of 'want' or 'order' or the end of the sentence
      if match = params[:text].match(/(?<=\bfrom\s|\bat\s)(.+?)(?=\bwant|$|\border)/i)
        from = match.captures.first || "I don't know where"
      end

      nexmo.send_message(from: '12192099266', 
                         to: params[:msisdn], 
                         text: "Thanks for using OrderBOT! Your order of #{wants} from #{from} will be ready in 15 minutes!")
    end

    head :ok, content_type: "text/html"
  end
end
