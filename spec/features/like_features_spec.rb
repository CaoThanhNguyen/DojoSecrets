require "rails_helper"
feature "Like features" do
    before do
        @user = create(:user)
        @secret = create(:secret, user:@user)
        log_in
        # @user2 = create(:user, email="email2@gmail.com")
        # @secret2 = create(:secret, user:@user2, content:"user2 secret")
        # visit "/secrets" unless current_path == "/secrets"
    end
    feature "secret has not been liked" do
        before do
            visit "/secrets" unless current_path == "/secrets"
        end
        scenario "like count updated correctly" do
            expect(page).to have_text(@secret.content) 
            expect(page).to have_text("0 likes")
        end
        scenario "display like button if you haven't liked secrets" do
            expect(page).to have_link("Like")
        end
        scenario "liking with update like count, like button not visible" do
            click_link "Like"
            # expect(current_path).to eq("/users/#{@user.id}")
            expect(page).to have_text("1 likes")
        end
    end
    feature "secret has been liked" do
        before (:each) do
            @like = create(:like, user:@user, secret:@secret)
            visit "/secrets"
        end
        scenario "unlike button is visible" do
            expect(page).to have_link("Unlike")
        end
        scenario "unliking will update like count" do
            click_link "Unlike"
            expect(page).to_not have_link("Unlike")
            expect(page).to have_text("0 likes") 
        end
    end
end