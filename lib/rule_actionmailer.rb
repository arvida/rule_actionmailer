require "base64"
require "uri"
require "json"
require "net/http"
require "rule_actionmailer/version"

module RuleActionmailer
  class DeliveryMethod
    attr_reader :mailer

    def initialize(options)
      @base_url = options[:base_url]
      @api_key  = options[:api_key]
      @uri = URI.parse("#{@base_url}/transactionals")
      @http = Net::HTTP.new(@uri.host, @uri.port)
    end

    def deliver!(mail)
      req = Net::HTTP::Post.new(@uri.request_uri, "Content-Type" => "application/json")
      req.body = mail_content(mail).merge(apikey: @api_key).to_json
      @http.request(req).body
    end

    def mail_content(mail)
      {
        transaction_type: "email",
        transaction_name: mail.subject,
        subject: mail.subject,
        from: {
          name: "Lärarförbundet",
          email: mail[:from].addresses.first
        },
        to: {
          email: mail[:to].addresses.first
        },
        content: multipart_content(mail)
      }
    end

    def multipart_content(mail)
      if mail.text_part.nil?
        return {
          plain: Base64.strict_encode64(mail.body.decoded),
          html: Base64.strict_encode64(mail.body.decoded)
        }
      end

      {
        plain: Base64.strict_encode64(mail.text_part.decoded),
        html: Base64.strict_encode64(mail.html_part.decoded)
      }
    end

    alias_method :deliver, :deliver!
    alias_method :deliver_now, :deliver!
    alias_method :deliver_later, :deliver!
  end
end
