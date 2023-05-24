module BigCheck
  class Client
    ENDPOINT = 'https://api.bigregister.nl/zksrv/soap/4'
    require 'savon'
    attr_reader :hcp, :response, :client, :classifications

    def initialize
      @client = @client || Savon.client(wsdl: ENDPOINT, log: false, raise_errors: false, ssl_verify_mode: :none)
    end

    def check_by_big(big_number)
      message = {
        "WebSite" => "Ribiz",
        "RegistrationNumber" => big_number
      }
      begin
        @response = @client.call(:list_hcp_approx4, message: message)
        fail unless @response.http.code == 200
        @hcp = BigCheck::HCP.new(@response.body)
        return true
      rescue Savon::SOAPFault => e
        raise NotFoundError.new(e.message)
      rescue Savon::HTTPError => e
        raise ServerNotFoundError.new(e.message)
      rescue => e
        raise UnknownError.new(e.message)
      end
    end

    def get_classifications
      begin
        @response = @client.call(:get_ribiz_reference_data)
        fail unless @response.http.code == 200
        @classifications = BigCheck::Classifications.new(@response.body)
      rescue Savon::SOAPFault => e
        raise NotFoundError.new(e.message)
      rescue Savon::HTTPError => e
        raise ServerNotFoundError.new(e.message)
      rescue => e
        raise UnknownError.new(e.message)
      end
    end

  end

  class NotFoundError < StandardError
  end

  class ServerNotFoundError < StandardError
  end

  class UnknownError < StandardError
  end

end
