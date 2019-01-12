module BigCheck
  class HCP
    attr_accessor :response

    SPECIALISM = {"2" => "Allergologie", "3" => "Anesthesiologie","4" => "Algemene gezondheidszorg",
                  "5" => "Medische milieukunde", "6" => "Tuberculosebestrijding", "7" => "Arbeid en gezondheid",
                  "8" => "Arbeid en gezondheid - bedrijfsgeneeskunde", "10" => "Cardiologie", "11" => "Cardio-thoracale chirurgie",
                  "12" => "Dermatologie en venerologie", "13" => "Leer van maag-darm-leverziekten", "14" => "Heelkunde",
                  "15" => "Huisartsgeneeskunde", "16" => "Inwendige geneeskunde", "17" => "Jeugdgezondheidszorg", "18" => "Keel- neus- oorheelkunde",
                  "19" => "Kindergeneeskunde", "20" => "Klinische chemie", "21" => "Klinische genetica", "22" => "Klinische geriatrie",
                  "23" => "Longziekten en tuberculose", "24" => "Medische microbiologie", "25" => "Neurochirurgie",
                  "26" => "Neurologie", "30" => "Nucleaire geneeskunde", "31" => "Oogheelkunde", "32" => "Orthopedie",
                  "33" => "Pathologie", "34" => "Plastische chirurgie", "35" => "Psychiatrie", "39" => "Radiologie",
                  "40" => "Radiotherapie", "41" => "Reumatologie", "42" => "Revalidatiegeneeskunde", "43" => "Maatschappij en gezondheid",
                  "44" => "Sportgeneeskunde", "45" => "Urologie", "46" => "Obstetrie en gynaecologie", "47" => "Verpleeghuisgeneeskunde",
                  "48" => "Arbeid en gezondheid - verzekeringsgeneeskunde", "50" => "Zenuw- en zielsziekten", "53" => "Dento-maxillaire orthopaedie",
                  "54" => "Mondziekten en kaakchirurgie", "55" => "Maatschappij en gezondheid", "56" => "Medische zorg voor verstandelijke gehandicapten",
                  "60" => "Ziekenhuisfarmacie", "61" => "Klinische psychologie", "62" => "Interne geneeskunde-allergologie"
                  }

    PROFESSION = {"01" => "Artsen", "02" => "Tandartsen", "03" => "Verloskundigen", "04" => "Fysiotherapeuten",
                   "16" => "Psychotherapeuten", "17" => "Apothekers", "18" => "Apotheekhoudende artsen", "25" => "Gz-psychologen",
                   "30" => "Verpleegkundigen", "87" => "Optometristen", "88" => "Huidtherapeuten", "89" => "Dietisten",
                   "90" => "Ergotherapeuten", "91" => "Logopedisten", "92" => "Mondhygienisten", "93" => "Oefentherapeuten Mensendieck",
                   "94" => "Oefentherapeuten Cesar", "95" => "Orthoptisten", "96" => "Podotherapeuten", "97" => "Radiodiagnostisch laboranten",
                   "98" => "Radiotherapeutisch laboranten", "99" => "Onbekend", "83" => "Apothekersassistenten", "85" => "Tandprothetica",
                   "86" => "Verzorgenden individuele gezondheidszorg"
                  }

    def initialize response
      r = response[:list_hcp_approx4_result][:list_hcp_approx] ||= {}
      @response = r[:list_hcp_approx4] unless r.empty?
      @valid = (r.empty?) ? false : true
    end

    [:birth_surname, :mailing_name, :prefix, :initial, :gender].each do |method|
      define_method "#{method}" do
        return false unless valid?
        return @response[method]
      end
    end

    def profession
      return false if invalid? || @response[:article_registration].nil?
      article = @response[:article_registration][:article_registration_ext_app]
      article = [article] if article.is_a? Hash
      arr = []
      article.each do |art|
        result[:code] = article[:professional_group_code]
        result[:value] = PROFESSION[article[:professional_group_code]]
        result[:from] = article[:article_registration_start_date]
        result[:to] =article[:article_registration_end_date]
        arr << result
      end
      return arr
    end

    def specialism
      return false if invalid? || @response[:specialism].nil?
      article = @response[:specialism][:specialism_ext_app1]
      article = [article] if article.is_a? Hash
      arr = []
      article.each do |art|
        result[:code] = article[:type_of_specialism_id]
        result[:value] = SPECIALISM[article[:type_of_specialism_id]]
        arr << result
      end
      return arr
    end

    def valid?
      @valid
    end

    def invalid?
      !@valid
    end

    def active?
      end_date = Date.parse(article_registration_end_date)
      return !end_date.past?
    end

    alias_method :name, :birth_surname
    alias_method :registered_from, :article_registration_start_date
    alias_method :registered_to, :article_registration_end_date

    private

      def loop_through_values object, item, lookup
        array = []
        object.each do |o|
          code = o[item]
          array.push({code: code, value: lookup[code]})
        end
        array
      end

  end
end
