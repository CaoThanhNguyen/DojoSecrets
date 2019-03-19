require "rails_helper"
feature "User features " do
    feature "user sign-up" do
        before do
            visit "/users/new"
        end
        scenario "visit sign-up page" do 
            expect(page).to have_field("name")
            expect(page).to have_field("email")
            expect(page).to have_field("password")
            expect(page).to have_field("password_confirmation")
        end
        scenario "with improper inputs, redirects back to sign in and shows validation" do
            click_button "Sign Up"
            expect(current_path).to eq("/users/new")
            expect(page).to have_text("can't be blank")
        end
        scenario "with proper inputs, create user and redirects to login page" do
            register
            expect(current_path).to eq("/users/#{User.last.id}")
        end
    end
    feature "user dashboard" do
        before do
            @user = create(:user)
        end
        scenario "displays user information" do
            log_in
            expect(current_path).to eq("/users/#{@user.id}")
            expect(page).to have_text("#{@user.name}")
            expect(page).to have_link("Edit")
            expect(page).to have_button("Delete")
        end
    end
    feature "user settings" do
        before do
            @user = create(:user)
            log_in
        end
        feature "user edit settings" do
            before do
                click_link "Edit"
            end
            scenario "visit users edit page" do
                expect(page).to have_field("name")
                expect(page).to have_field("email")
            end
            scenario "inputs filled out correctly" do
                expect(find_field("name").value).to eq(@user.name)
                expect(find_field("email").value).to eq(@user.email)
            end
            scenario "incorrectly updates infomration - empty name" do
                fill_in "name", with: ""
                click_button "Update"
                expect(current_path).to eq("/users/#{@user.id}/edit")
                expect(page).to have_text("can't be blank")
            end
            scenario "incorrectly updates infomration - empty email" do
                fill_in "email", with: ""
                click_button "Update"
                expect(current_path).to eq("/users/#{@user.id}/edit")
                expect(page).to have_text("can't be blank")
            end
            scenario "incorrectly updates infomration - invalid email" do
                fill_in "email", with: "newinvalidemail"
                click_button "Update"
                expect(current_path).to eq("/users/#{@user.id}/edit")
                expect(page).to have_text("only allows valid email")
            end
            scenario "correct updates information" do
                fill_in "name", with: "White Sky"
                fill_in "email", with: "white.sky@gmail.com"
                click_button "Update"
                expect(current_path).to eq("/users/#{@user.id}")
                expect(page).to have_text("White Sky")
            end
        end
        feature "user delete account" do
            scenario "user click delete button to delete his/her account" do
                click_button "Delete Account"
                expect(current_path).to eq("/users/new")
            end
        end
    end
end