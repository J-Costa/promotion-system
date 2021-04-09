class PromotionMailer < ApplicationMailer
  def approval_email(promotion:, approver:)
    @promotion = promotion
    @approver = approver
    mail(to: @promotion.user.email,
         subject: "Sua promoção \"#{promotion.name}\" foi aprovada")
  end
end
