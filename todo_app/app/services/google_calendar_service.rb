class GoogleCalendarService
  def initialize(user)
    @user = user
  end

  def create_or_update_event_for_task(task)
    return unless google_user?
    return if task.due_date.blank?

    time_zone  = Time.zone.tzinfo.name
    start_time = task.due_date.in_time_zone
    end_time   = start_time + 1.hour

    event = Google::Apis::CalendarV3::Event.new(
      summary: task.title,
      description: task.description,
      start: {
        date_time: start_time.iso8601,
        time_zone: time_zone
      },
      end: {
        date_time: end_time.iso8601,
        time_zone: time_zone
      },
      attendees: [{ email: @user.email }],
      reminders: { use_default: true }
    )

    client = authorized_client

    result =
      if task.google_event_id.present?
        begin
          client.update_event("primary", task.google_event_id, event)
        rescue Google::Apis::ClientError => e
          raise e unless e.status_code == 404
          create_new_event(client, event, task)
        end
      else
        create_new_event(client, event, task)
      end

    result.html_link
  rescue Google::Apis::Error => e
    Rails.logger.error "Erro ao manipular evento: #{e.message}"
    nil
  end

  def delete_event_for_task(task)
    return unless google_user?
    return if task.google_event_id.blank?

    client = authorized_client
    client.delete_event("primary", task.google_event_id)
    task.update(google_event_id: nil)
  rescue Google::Apis::Error => e
    Rails.logger.error "Erro ao excluir evento: #{e.message}"
  end

  private

  def google_user?
    @user.provider == "google_oauth2" && @user.uid.present?
  end

  def create_new_event(client, event, task)
    result = client.insert_event("primary", event)
    task.update(google_event_id: result.id)
    result
  end

  def authorized_client
    client = Google::Apis::CalendarV3::CalendarService.new
    client.client_options.application_name = "ToDone"
    client.authorization = user_credentials
    client
  end

  def user_credentials
    raise "Usuário não autenticado via Google" unless google_user?

    auth = Signet::OAuth2::Client.new(
      token_credential_uri: "https://oauth2.googleapis.com/token",
      client_id: ENV.fetch("GOOGLE_CLIENT_ID"),
      client_secret: ENV.fetch("GOOGLE_CLIENT_SECRET"),
      refresh_token: @user.refresh_token
    )

    if @user.token_expires_at.present? && @user.token_expires_at < Time.current
      raise "Usuário sem refresh_token. Faça login novamente com Google." if @user.refresh_token.blank?

      auth.refresh!
      @user.update!(
        token: auth.access_token,
        token_expires_at: Time.current + auth.expires_in.seconds
      )
    else
      auth.access_token = @user.token
    end

    auth
  end
end
