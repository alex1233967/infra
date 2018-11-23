module SessionsHelper
  def sign_in(session)
    remember_token = Session.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    session.update_attribute(:remember_token, Session.encrypt(remember_token))
    self.current_session = session
  end

  def current_session=(session)
    @current_session = session
  end

  def current_session?(session)
    session == current_session
  end

  def current_session
    remember_token = Session.encrypt(cookies[:remember_token])
    @current_session ||= Session.find_by(remember_token: remember_token)
  end

  def signed_in?
    !current_session.nil?
  end

  def sign_out
    current_session.update_attribute(:remember_token, Session.encrypt(Session.new_remember_token))
    cookies.delete(:remember_token)
    self.current_session = nil
  end
end
