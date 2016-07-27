class Ability
  include CanCan::Ability

  def initialize(user)
    
    if user && user.class == Admin
      can :access, :rails_admin
      can :dashboard
      can :manage, [Author, Admin, Book, Coupon, Category, Rating]
      can [:read, 
           :complete_order, 
           :ship_order, 
           :cancel_order, 
           :bulk_complete_orders], Order
      cannot :create, Rating
    elsif user && user.class == Customer
      can :manage, Address, billing_address_for_id: user.id
      can :manage, Address, shipping_address_for_id: user.id
      can :read, Country
      can :manage, CreditCard, customer_id: user.id
      can [:read, :update], Customer, id: user.id
      can [:create, :read], Order, customer_id: user.id
      can [:update, :destroy], Order, customer_id: user.id, state: 'in_progress'
      can :manage, OrderItem, order: { 
        customer_id: user.id, state: 'in_progress' }  
      can :manage, Rating, customer_id: user.id
    end
   
    can :manage, Order, customer_id: nil
    can :manage, OrderItem, order_id: nil
    can :read, Author
    can :read, Book
    can :read, Category
    can :read, Rating
 
  end
end
