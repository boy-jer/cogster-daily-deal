module PurchasesHelper

  def card_selection
    params[:purchase][:type] if params[:purchase].present?
  end

  def credit_card_options
    %w(Visa MasterCard Discover\ Card American\ Express).zip(%w(visa master discover american_express))
  end

  def redemption_amount(project, period)
    number_to_currency(project.min_redemption_amount(period) / 100.0)
  end

  def redemption_schedule(project, period)
    start, finish = project.redemption_period(period)
    "#{start.strftime("%b %d")} to #{finish.strftime("%b %d")}"
  end
end
