defmodule GameServices.AuthenticationTest do
  use GameServices.DataCase

  alias GameServices.Authentication

  describe "tickets" do
    alias GameServices.Authentication.Ticket

    @valid_attrs %{
      client_token: "some client_token",
      salt: "some salt",
      server_token: "some server_token",
      username: "some username"
    }
    @update_attrs %{
      client_token: "some updated client_token",
      salt: "some updated salt",
      server_token: "some updated server_token",
      username: "some updated username"
    }
    @invalid_attrs %{client_token: nil, salt: nil, server_token: nil, username: nil}

    def ticket_fixture(attrs \\ %{}) do
      {:ok, ticket} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Authentication.create_ticket()

      ticket
    end

    test "list_tickets/0 returns all tickets" do
      ticket = ticket_fixture()
      assert Authentication.list_tickets() == [ticket]
    end

    test "get_ticket!/1 returns the ticket with given id" do
      ticket = ticket_fixture()
      assert Authentication.get_ticket!(ticket.id) == ticket
    end

    test "create_ticket/1 with valid data creates a ticket" do
      assert {:ok, %Ticket{} = ticket} = Authentication.create_ticket(@valid_attrs)
      assert ticket.client_token == "some client_token"
      assert ticket.salt == "some salt"
      assert ticket.server_token == "some server_token"
      assert ticket.username == "some username"
    end

    test "create_ticket/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Authentication.create_ticket(@invalid_attrs)
    end

    test "update_ticket/2 with valid data updates the ticket" do
      ticket = ticket_fixture()
      assert {:ok, %Ticket{} = ticket} = Authentication.update_ticket(ticket, @update_attrs)
      assert ticket.client_token == "some updated client_token"
      assert ticket.salt == "some updated salt"
      assert ticket.server_token == "some updated server_token"
      assert ticket.username == "some updated username"
    end

    test "update_ticket/2 with invalid data returns error changeset" do
      ticket = ticket_fixture()
      assert {:error, %Ecto.Changeset{}} = Authentication.update_ticket(ticket, @invalid_attrs)
      assert ticket == Authentication.get_ticket!(ticket.id)
    end

    test "delete_ticket/1 deletes the ticket" do
      ticket = ticket_fixture()
      assert {:ok, %Ticket{}} = Authentication.delete_ticket(ticket)
      assert_raise Ecto.NoResultsError, fn -> Authentication.get_ticket!(ticket.id) end
    end

    test "change_ticket/1 returns a ticket changeset" do
      ticket = ticket_fixture()
      assert %Ecto.Changeset{} = Authentication.change_ticket(ticket)
    end
  end
end
