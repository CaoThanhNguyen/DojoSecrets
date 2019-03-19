require "rails_helper"
RSpec.describe UsersController, type: :controller do
    before do
        @user = create(:user)
    end
    context "when not logged in" do
        before do
            session[:user_id] = nil
        end
        it "cannot access show" do
            get :show, params: {user_id: @user}
            expect(response).to redirect_to("/sessions/new")
        end
        it "cannot access edit" do
            get :edit, params: {user_id: @user}
            expect(response).to redirect_to("/sessions/new")
        end
        it "cannot access update" do
            patch :update, params:{user_id: @user}
            expect(response).to redirect_to("/sessions/new")
        end
        it "cannot access destroy" do
            delete :destroy, params: {user_id: @user}
            expect(response).to redirect_to("/sessions/new")
        end
    end
    context "when signed in as the wrong user" do 
        before do
            session[:user_id] = @user.id
            @user2 = create(:user, email:"email2@gmail.com")
        end
        it "cannot access another user's profile page" do
            get :show, params: {user_id:@user2}
            expect(response).to redirect_to("/sessions/new")
        end
        it "cannot access the edit page of another user" do
            get :edit, params: {user_id:@user2}
            expect(response).to redirect_to("/sessions/new")
        end
        it "cannot update another user" do
            patch :update, params: {user_id:@user2}
            expect(response).to redirect_to("/sessions/new")
        end
        it "cannot destroy another user" do
            delete :destroy, params: {user_id:@user2}
            expect(response).to redirect_to("/sessions/new")
        end
    end
end