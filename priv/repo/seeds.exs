# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Mfarms.Repo.insert!(%Mfarms.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Mfarms.Repo.insert!(%Mfarms.Marketplace.Farmer{
  first_name: "John",
  last_name: "Doe",
  phone_number: "08098765432",
  location: "Abuja",
  chat_id: "87654321",
  contact_type: :telegram,
  listings: [
    %Mfarms.Marketplace.Listing{
      name: "Rice",
      price: 2500.0,
      currency: "NGN",
      quantity: 150,
      unit: "kg"
    },
    %Mfarms.Marketplace.Listing{
      name: "Tomatoes",
      price: 300.0,
      currency: "NGN",
      quantity: 20,
      unit: "kg"
    },
    %Mfarms.Marketplace.Listing{
      name: "Beans",
      price: 1800.0,
      currency: "NGN",
      quantity: 100,
      unit: "kg"
    }
  ]
})

Mfarms.Repo.insert!(%Mfarms.Marketplace.Farmer{
  first_name: "Jane",
  last_name: "Smith",
  phone_number: "08055555555",
  location: "Port Harcourt",
  chat_id: "55555555",
  contact_type: :telegram,
  listings: [
    %Mfarms.Marketplace.Listing{
      name: "Eggs",
      price: 50.0,
      currency: "NGN",
      quantity: 100,
      unit: "pieces"
    },
    %Mfarms.Marketplace.Listing{
      name: "Mango",
      price: 200.0,
      currency: "NGN",
      quantity: 40,
      unit: "pieces"
    },
    %Mfarms.Marketplace.Listing{
      name: "Chicken",
      price: 1000.0,
      currency: "NGN",
      quantity: 10,
      unit: "pieces"
    }
  ]
})

Mfarms.Repo.insert!(%Mfarms.Marketplace.Farmer{
  first_name: "David",
  last_name: "Johnson",
  phone_number: "08011111111",
  location: "Kano",
  chat_id: "11111111",
  contact_type: :telegram,
  listings: [
    %Mfarms.Marketplace.Listing{
      name: "Maize",
      price: 300.0,
      currency: "NGN",
      quantity: 200,
      unit: "kg"
    },
    %Mfarms.Marketplace.Listing{
      name: "Watermelon",
      price: 150.0,
      currency: "NGN",
      quantity: 10,
      unit: "pieces"
    },
    %Mfarms.Marketplace.Listing{
      name: "Onions",
      price: 400.0,
      currency: "NGN",
      quantity: 30,
      unit: "kg"
    }
  ]
})

Mfarms.Repo.insert!(%Mfarms.Marketplace.Farmer{
  first_name: "Sarah",
  last_name: "Williams",
  phone_number: "08022222222",
  location: "Enugu",
  chat_id: "22222222",
  contact_type: :telegram,
  listings: [
    %Mfarms.Marketplace.Listing{
      name: "Cabbage",
      price: 150.0,
      currency: "NGN",
      quantity: 20,
      unit: "pieces"
    },
    %Mfarms.Marketplace.Listing{
      name: "Carrots",
      price: 200.0,
      currency: "NGN",
      quantity: 30,
      unit: "kg"
    },
    %Mfarms.Marketplace.Listing{
      name: "Ginger",
      price: 500.0,
      currency: "NGN",
      quantity: 10,
      unit: "kg"
    }
  ]
})
