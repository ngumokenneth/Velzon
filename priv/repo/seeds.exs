# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Velzon.Repo.insert!(%Velzon.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

for title <- ["Home Improvement", "Power Tools", "Gardening", "Books", "Education", "Electronics", "Computers", "phones", "clothes", "Kitchen", "cars"] do
  {:ok, _} = Velzon.Categories.create_category(%{title: title})
end
