module CreditCardsHelper
  def is_exp_year_or_month?(sym)
    [:expiration_year, :expiration_month].include?(sym)
  end
end
