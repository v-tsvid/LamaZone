class AddStateToRatings < ActiveRecord::Migration
  def change
    add_column :ratings, :state, :string
  end
end
