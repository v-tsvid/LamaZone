# require 'features/features_spec_helper'

# feature "access to admin panel" do 
#   given(:admin) { FactoryGirl.create :admin, 
#                   email:                 'admin@mail.com', 
#                   password:              '12345678',
#                   password_confirmation: '12345678' }


#   context "signed in admin" do
#     background { login_as admin, scope: :admin }

#     # scenario "has a link to admin panel" do
#     #   visit root_path

#     #   expect(page).to have_link 'Admin Panel'
#     # end
    
#     # scenario "gets an access to admin panel" do
#     #   visit rails_admin_path

#     #   expect(page).to have_content 'Dashboard'
#     # end   
#   end

#   context "unsigned in user" do
#     background do
#       logout admin
#     end

#     # scenario "has no link to admin panel" do
#     #   visit root_path

#     #   expect(page).not_to have_link 'Admin Panel'
#     # end
    
#     # scenario "does not get access to admin panel" do
#     #   visit rails_admin_path

#     #   expect(page).not_to have_content 'Dashboard'
#     # end
#   end
# end