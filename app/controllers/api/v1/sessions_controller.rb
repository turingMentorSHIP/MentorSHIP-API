class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token

  def create
    github_authenticator = GithubAuthenticator.new(github_auth_code)
    user_factory = UserFactory.new(github_authenticator)
    user = user_factory.find_or_create_user

    render json: user, status: :created
  end

  def session_id
    @session_id = current_session
  end

  def user_name
    @user_name = current_name
  end

  private

  def github_auth_code
    params.require(:'github-auth-code')
  end
end
