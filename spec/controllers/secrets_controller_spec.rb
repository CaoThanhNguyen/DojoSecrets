require "rails_helper"
RSpec.describe SecretsController, type: :controller do
    before do
        @user = create(:user)
        @secret = create(:secret, user:@user)
    end
    context "when not logged in" do
        before do
            session[:user_id] = nil
        end
        it "cannot access secrets page" do
            get :index
            expect(response).to redirect_to("/sessions/new")
        end
        it "cannot access create" do
            post :create, params: {user_id: @user}
            expect(response).to redirect_to("/sessions/new")
        end
        it "cannot access destroy" do
            delete :destroy, params: {user_id: @user, secret_id: @secret}
            expect(response).to redirect_to("/sessions/new")
        end
        it "cannot access like" do
            get :like, params: {user_id: @user, secret_id: @secret}
            expect(response).to redirect_to("/sessions/new")
        end
        it "cannot access unlike" do
            get :unlike, params: {user_id: @user, secret_id: @secret}
            expect(response).to redirect_to("/sessions/new")
        end
    end
    context "when signed in as the wrong user" do
        before do
            @user2 = create(:user, email:"email2@gmail.com")
            @secret2 = create(:secret, user:@user2, content:"Secret 2")
            session[:user_id] = @user.id
        end
        it "cannot destroy another user's secret" do
            delete :destroy, params:{user_id:@user, secret_id:@secret2}
            expect(response).to redirect_to("/sessions/new")
            delete :destroy, params:{user_id:@user2, secret_id:@secret2}
            expect(response).to redirect_to("/sessions/new")
        end
        it "cannot unlike another user's secret" do
            @like = create(:like, user:@user, secret:@secret)
            get :unlike, params:{user_id:@user2, secret_id:@secret}
            expect(response).to redirect_to("/sessions/new")
        end
    end
end