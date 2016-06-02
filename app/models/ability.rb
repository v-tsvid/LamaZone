class Ability
  include CanCan::Ability

  def initialize(customer)
    customer ||= Customer.new
    
    if customer
      can :manage, Address, billing_address_for_id: customer.id
      can :manage, Address, shipping_address_for_id: customer.id
      can :read, Country
      can :manage, CreditCard, customer_id: customer.id
      can [:read, :update], Customer, id: customer.id
      can [:create, :read], Order, customer_id: customer.id
      can [:update, :destroy], Order, customer_id: customer.id, state: 'in_progress'
      can :manage, OrderItem, order: { customer_id: customer.id, state: 'in_progress' }  
      can :manage, Rating, customer_id: customer.id
    end

    can :read, Author
    can :read, Book
    can :read, Category
    can :read, Rating
    
    can :manage, Order, customer_id: nil
    can :manage, OrderItem, order_id: nil
  end
end
