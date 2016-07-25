module CreditCardsHelper

  def years_for_select
    Array('2015'..'2029')
  end

  def months_for_select
    Array('01'..'12')
  end

  def credit_card_errors?(errors, attr_sym)
    errors && errors["credit_card.#{attr_sym}"] 
  end

  def card_number_errors?(errors)
    errors && errors["credit_card.credit_card"]
  end

  def card_date_errors?(errors)
    errors && errors["base"]
  end

  def credit_card_errors_list(errors, attr_sym)
    "#{errors["credit_card.#{attr_sym}"].uniq.join(', ')}"
  end

  def card_number_errors_list(errors)
    "#{errors["credit_card.credit_card"].uniq.join(', ')}"
  end

  def card_date_errors_list(errors)
    "#{errors["base"].uniq.join(', ')}"
  end

  def is_exp_year_or_month?(sym)
    [:expiration_year, :expiration_month].include?(sym)
  end
end
