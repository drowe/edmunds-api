defmodule Edmunds.Repo.Migrations.AddSupportingTables do
	use Ecto.Migration

	def change do
		create table(:years) do
			add :value,    :integer
		end
		create index(:years, [:value])

		create table(:makes) do
			add :name,		:string
			add :nice_name,	:string
			add :year_id,	:integer
		end
		create index(:makes, [:year_id])

		create table(:models) do
			add :name,		:string
			add :nice_name,	:string
			add :year_id,	:integer
			add :make_id,	:integer
		end
		create index(:models, [:year_id])
		create index(:models, [:make_id])
	end
end
