class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    auth = request.env["omniauth.auth"]
    user = User.from_google(auth)

    sign_in_and_redirect user, event: :authentication
  rescue StandardError => e
    Rails.logger.error("[Google OAuth] #{e.class}: #{e.message}")
    redirect_to new_user_session_path, alert: "Não foi possível entrar com Google."
  end

  def failure
    redirect_to new_user_session_path, alert: "Falha no login com Google."
  end
end
