  module Encryptable
   def signable_string
     ""
   end
    def verify_creator_signature
      verify_signature(creator_signature, person)
    end
    
    def verify_signature(signature, person)
      if person.nil?
        Rails.logger.info("Verifying sig on #{signable_string} but no person is here")
        return false
      elsif person.key.nil?
        Rails.logger.info("Verifying sig on #{signable_string} but #{person.real_name} has no key")
        return false
      elsif signature.nil?
        Rails.logger.info("Verifying sig on #{signable_string} but #{person.real_name} did not sign")
        return false
      end
      Rails.logger.info("Verifying sig on #{signable_string} from person #{person.real_name}")
      verify_signature_from_key(signature, person.key) 
    end
   
    def verify_signature_from_key signature, key
      validity = key.verify "SHA", Base64.decode64(signature), signable_string
      Rails.logger.info("Validity: #{validity}")
      validity
    end

    protected
    def sign_if_mine
      if self.person == User.owner
        self.creator_signature = sign
      end
    end

    def sign
      sign_with_key(User.owner.key)
    end

    def sign_with_key(key)
      Rails.logger.info("Signing #{signable_string}")
      Base64.encode64(key.sign "SHA", signable_string)
      
    end
  end

