class Promotion < ApplicationRecord
    has_many :coupons, dependent: :destroy
    
    validates :code, :name, :discount_rate, :coupon_quantity, :expiration_date,  presence: true
    validates :code, :name, uniqueness: true
    validate :expiration_date_cannot_be_in_the_past

    # TODO: adicionar validação para edicão se cupom tiver gerado

    def generate_coupons!
        return if coupons?
        
        (1..coupon_quantity).each do |number|
            coupons.create!(code: "#{code}-#{'%04d' % number}")
        end
    end

    def coupons?
        coupons.any?
    end

    def self.search(term)
      @promotions = Promotion.where('name LIKE ?', "%#{term}%")
    end
    
    
    private
    
      def expiration_date_cannot_be_in_the_past
        if expiration_date.present? && expiration_date < Date.current
          errors.add(:expiration_date, I18n.t('cant_be_in_the_past'))
        end
      end
    
end
