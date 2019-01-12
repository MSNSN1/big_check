module BigCheck
  class Client
    ENDPOINT = 'http://webservices.cibg.nl/Ribiz/OpenbaarV4.asmx?wsdl'
    require 'savon'

    def initialize
      @client = Savon.client(wsdl: ENDPOINT, log: false)
    end

    def check_by_big(big)
      message = {
        "WebSite" => "Ribiz",
        "RegistrationNumber" => big_number
      }
      begin
        response = @client.call(:list_hcp_approx3, message: message)
        format_response(response)
      rescue Savon::SOAPFault => e
        raise NotFoundError.new(e.message)
      end
    end

  end

  class NotFoundError < StandardError
  end

end
