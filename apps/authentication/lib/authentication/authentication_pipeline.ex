defmodule Authentication.AuthenticationPipeline do
  @moduledoc false

  ## load guardian session with connection data

  use Guardian.Plug.Pipeline, otp_app: :authentication
  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
end