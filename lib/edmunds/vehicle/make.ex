defmodule Edmunds.Vehicle.Make do
	use Ecto.Schema

	use Edmunds.Vehicle
	alias Edmunds.Vehicle.Model

	def fetch(state) do
		request(initial_url, [], %{state: state})
	end

	def handle(make \\ %{}) do
		# Save the MAKE, then pass the Models array to be handled by the Model object.
		m = Repo.insert!(%Make{
			name: make["name"],
			nice_name: make["niceName"]
		})

		spawn(fn -> 
			make
			|> Map.fetch!("models")
			|> Enum.map(fn(models) ->
				Model.handle(models, m)
			end)
		end)
	end

	def initial_url do
		"/vehicle/v2/makes"
	end

	def process(results) do
		results
		|> Map.fetch!("makes")
		|> Enum.map(fn (make) ->
			spawn(fn -> 
				handle(make)
			end)
		end)
	end

	schema "makes" do
		field :name,		:string
		field :nice_name, 	:string
		field :year_id,		:integer
	end
end