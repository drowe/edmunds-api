defmodule Edmunds.Vehicle.Model do
	use Ecto.Schema

	require Logger

	def handle(model, make \\ %{}) do

		m = Repo.insert!(%Model{
			name: model["name"],
			nice_name: model["niceName"],
			make_id: make[:id]
		})
	end

	schema "models" do
		field :name,		:string
		field :nice_name,	:string
		field :year_id,		:integer
		field :make_id,		:integer
	end
end