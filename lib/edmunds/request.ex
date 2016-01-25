defmodule Edmunds.Request do
	use HTTPoison.Base
	alias Edmunds.Error
	require Logger

	@default_params %{api_key: "REPLACE ME"}
	def get_body(url, headers \\ [], opts \\ %{}) do
		case get(url, headers, params: Map.merge(@default_params, opts)) do
			{:ok, r} -> handle_response(r, "GET_BODY #{url}")
			{:error, error} -> %Error{reason: error}
		end
	end

	def get_error_message(html) do
		html
			|> Poison.decode!()
			|> Map.fetch!("message")
	end

	def handle_response(r, action \\ "") do
		Logger.info action
		case r.status_code do
			200 -> {:ok, Poison.decode!(r.body)}
			204 -> {:ok, :ok}
			401 -> {:error, %Error{code: 401, reason: "Access Denied #{action} #{get_error_message(r.body)}"}}
			404 -> {:error, %Error{code: 404, reason: "Not found #{action}"}}
			422 -> {:error, %Error{code: 422, reason: "Unprocessable Entity"}}
			503 -> {:error, %Error{code: 503, reason: "Service Unavailable"}}
			502 -> {:error, %Error{code: 502, reason: "Bad Gateway"}}
			code -> {:error, %Error{code: code, reason: "Unprocessable Status Code #{r.status_code}"}}
		end
	end

	@url "https://api.edmunds.com/api"
	def process_url(url) do
		@url <> url
	end
end