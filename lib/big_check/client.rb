module BigCheck
  class Client
    ENDPOINT = 'http://webservices.cibg.nl/Ribiz/OpenbaarV4.asmx?wsdl'
    require 'savon'


    def self.check_by_big(big_number)
      @client = @client || Savon.client(wsdl: ENDPOINT, log: false)
      message = {
        "WebSite" => "Ribiz",
        "RegistrationNumber" => big_number
      }
      begin
        response = @client.call(:list_hcp_approx4, message: message)
        return BigCheck::HCP.new(response.body)
      rescue Savon::SOAPFault => e
        raise NotFoundError.new(e.message)
      end
    end

  end

  class NotFoundError < StandardError
  end

end
