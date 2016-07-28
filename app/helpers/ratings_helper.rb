module RatingsHelper

  def checked_rating_input(i, rate)
    rating_input(i,rate) + "checked='checked' />"
  end

  def unchecked_rating_input(i, rate)
    rating_input(i, rate) + " />"
  end

  private

    def rating_input(i, id)
      "<input name='star#{id}' type='radio' value=#{i} "\
      "class='star {half:true}' disabled='disabled'"
    end
end