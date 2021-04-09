class PromotionMailerPreview < ActionMailer::Preview
  def approval_email
    PromotionMailer
      .approval_email(approver: User.last, promotion: Promotion.last)
  end
end
