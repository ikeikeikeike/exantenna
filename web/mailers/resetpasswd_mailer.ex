defmodule Exantenna.ResetpasswdMailer do
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
      subject: "From Mailgun as reset password",
      text: """
      #{email} : #{confirm}
      """
    )

    send_email(
      to: email,
      from: @from,
      subject: gettext("Activation %{name}'s new password that's starting our sites management", name: @site_name),
      text: gettext("""
      Created opportunity that's a new password registration. Please activate your e-mail address with clicking the link below.

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
