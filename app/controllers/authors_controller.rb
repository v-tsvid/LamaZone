class AuthorsController < ApplicationController
  before_action :set_author, only: [:show]

  # # GET /authors/1
  # # GET /authors/1.json
  def show
  end

  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_author
      @author = Author.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def author_params
      params.require(:author).permit(:firstname, :lastname, :biography)
    end
end
