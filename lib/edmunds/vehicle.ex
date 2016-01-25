defmodule Edmunds.Vehicle do
	require Logger
	alias Edmunds.Vehicle.Make

	defmacro __using__(_) do
		quote do
			require Logger

			def handle_request_error(url, error) do
				Logger.info url
				case error do
				%Edmunds.Error{code: 403} -> Logger.error "Unauthorized! Check API key"
				%Edmunds.Error{code: 404} -> :ok
				%Edmunds.Error{code: 503} -> retry_request(url)
				_                            -> Logger.error "Unhandled error in Edmunds.Vehicle #{error}"
				end
			end

			def request(), do: initial_url() |> request()
			def request(url, headers \\ [], opts \\ %{}) do
				case Edmunds.Request.get_body(url, headers, opts) do
					{:ok, body} -> body
					{:error, error} -> handle_request_error(url, error)
				end
			end

			def retry_request(url), do: request(url)
		end
	end

	def update do 
		Logger.info "Updating all NEW Makes, Models"

		#spawn(fn -> 
			Make.fetch("new")
			|> Make.process
		#end)
	end
end