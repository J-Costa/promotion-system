class CouponsController < ApplicationController
    def disable
        @coupon = Coupon.find(params[:id])
        @coupon.disabled!
        redirect_to @coupon.promotion, notice: t('.success', code: @coupon.code, action: 'desabilitado')
    end

    def enable
        @coupon = Coupon.find(params[:id])
        @coupon.active!
        redirect_to @coupon.promotion, notice: t('.success', code: @coupon.code, action: 'ativado')
    end
    
end