class Ability
  include CanCan::Ability

  def initialize(customer)
    customer ||= Customer.new
    
    if customer.persisted?
      can :manage, Address, id: customer.shipping_address.try(:id)
      can :manage, Address, id: customer.billing_address.try(:id)
      can :read, Country
      can :manage, CreditCard, customer_id: customer.id
      can [:read, :update], Customer, id: customer.id
      can [:create, :read], Order, customer_id: customer.id
      can :manage, OrderItem, order: { customer_id: customer.id }  
      can [:create, :destroy], Rating, customer_id: customer.id
      can :read, Rating
      can [:update, :destroy], Rating, customer_id: customer.id
    end

    can :read, Author
    can :manage, Book
    can :read, Category
    can :read, Rating
  end
end
