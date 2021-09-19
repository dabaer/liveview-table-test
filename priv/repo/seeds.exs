# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Test.Repo.insert!(%Test.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
defmodule Blap do
  def random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end

Enum.each(1..250, fn x ->
  Test.Repo.insert!(%Test.OrderContext.Order{
    bol: "#{Enum.random(1000000..9999999)}",
    cod: Enum.random(100..999),
    dv: Enum.random(100..999),
    comment: Blap.random_string(10),
    consignee: Blap.random_string(10),
    delivery: Blap.random_string(10),
    shipper: Blap.random_string(10),
    pickup: Blap.random_string(10),
    customer: Blap.random_string(10),
    pu_date: NaiveDateTime.truncate(Timex.to_naive_datetime(Timex.shift(Timex.now(), days: x)), :second),
    dl_date: NaiveDateTime.truncate(Timex.to_naive_datetime(Timex.shift(Timex.now(), days: x + 1)), :second),
    terms: Blap.random_string(8),
    instruction: Blap.random_string(10)
  })
end)
