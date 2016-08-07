defmodule Exantenna.SignupMailer do
  import Exantenna.Gettext

  use Mailgun.Client, domain: Application.get_env(:exantenna, :mailer)[:mailgun_domain],
                      key: Application.get_env(:exantenna, :mailer)[:mailgun_key]

  @from Application.get_env(:exantenna, :mailer)[:from]
  @site_name Application.get_env(:exantenna, :sitemetas)[:default][:host]
  @site_email Application.get_env(:exantenna, :sitemetas)[:default][:email]

  def send_activation(email, confirm) do
    send_email(
      to: Application.get_env(:exantenna, :mailer)[:me],
      from: @from,
      subject: "From Mailgun as signup mail",
      text: """
      #{email} : #{confirm}
      """
    )

    send_email(
      to: email,
      from: @from,
      subject: gettext("Activate your %{name} media account to start sending email", name: @site_name),
      text: gettext("""
      Thanks for choosing %{name}. Please activate your account by clicking the link below.

      %{confirm}

      We may need to communicate important service level issues with you from time to time, so it's important we have an up-to-date email address for you on file.

      Despite you received this activation email if you haven't created %{name} acocunt.
      Would you be so kind as to contact to us ?
      %{email}

      Thanks.
      """, email: @site_email, name: @site_name, confirm: confirm)
    )
  end

end
