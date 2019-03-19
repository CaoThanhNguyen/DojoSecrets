require "rails_helper"
feature "secret feature" do
    before do
        @user = create(:user)
        @secret = create(:secret, user:@user)
        @user2 = create(:user, email:"email2@gmail.com")
        @secret2 = create(:secret, user:@user2, content:"user2 secret")
        log_in
    end
    feature "User personal secret page" do
        scenario "shouldn't see other user's secrets" do
            expect(page).to_not have_text(@secret2.content)
        end
        scenario "create a new secret" do
            fill_in "content", with: "my new secret"
            click_button "Create Secret"
            expect(current_path).to eq("/users/#{@user.id}")
            expect(page).to have_text("my new secret")
        end
        scenario "destroy secret from profile page, redirect to user profile page" do
            click_button "Delete"
            expect(current_path).to eq("/users/#{@user.id}")
            expect(page).to_not have_text(@secret.content)
        end
    end
    feature "Secret dashboard" do
        before do
            @secret = create(:secret, user:@user)
            visit "/secrets"
        end
        scenario "display everyone's secrets" do
            expect(page).to have_text(@secret.content)
            expect(page).to have_text(@secret2.content)
        end
        scenario "delete secret from index page, redirects to user profile page" do
            first(:button, 'Delete').click
            expect(current_path).to eq("/users/#{@user.id}")
            expect(page).to_not have_text(@secret2.content)
        end
    end
end