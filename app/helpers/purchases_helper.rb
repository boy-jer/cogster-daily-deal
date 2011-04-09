module PurchasesHelper

  def credit_card_options
    %w(Visa MasterCard Discover\ Card American\ Express).zip(%w(visa master discover american_express))
  end

  def menu
    breadcrumbs [link_to(@community.name, @community), link_to(@business.name, @business), "Make a Purchase"]
  end

  def purchase_options(project)
    project.min_amount.step(project.max_amount, 10).map{|n| [number_to_currency(n), n] }
  end

  def redemption_amount(project, period)
    number_to_currency(project.min_amount * project.redemption_percentage(period) / 100.0)
  end

  def redemption_schedule(project, period)
    start, finish = project.redemption_period(period)
    "#{start.strftime("%b %d")} to #{finish.strftime("%b %d")}"
  end
end
