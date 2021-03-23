class Promotion < ApplicationRecord
    has_many :coupons, dependent: :destroy
    
    validates :code, :name, :discount_rate, :coupon_quantity, :expiration_date,  presence: true
    # TODO: adicionar validação customizada para data
    # TODO: adicionar validação para edicão se cupom tiver gerado
    validates :code, :name, uniqueness: true

    def generate_coupons!
        return if coupons?
        
        (1..coupon_quantity).each do |number|
            coupons.create!(code: "#{code}-#{'%04d' % number}")
        end
    end

    def coupons?
        coupons.any?
    end

    private
    
    
end
