defmodule GameServicesWeb.TicketControllerTest do
  use GameServicesWeb.ConnCase

  alias GameServices.Authentication

  @create_attrs %{
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

  def fixture(:ticket) do
    {:ok, ticket} = Authentication.create_ticket(@create_attrs)
    ticket
  end

  describe "index" do
    test "lists all tickets", %{conn: conn} do
      conn = get(conn, Routes.ticket_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Tickets"
    end
  end

  describe "new ticket" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.ticket_path(conn, :new))
      assert html_response(conn, 200) =~ "New Ticket"
    end
  end

  describe "create ticket" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.ticket_path(conn, :create), ticket: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.ticket_path(conn, :show, id)

      conn = get(conn, Routes.ticket_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Ticket"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.ticket_path(conn, :create), ticket: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Ticket"
    end
  end

  describe "edit ticket" do
    setup [:create_ticket]

    test "renders form for editing chosen ticket", %{conn: conn, ticket: ticket} do
      conn = get(conn, Routes.ticket_path(conn, :edit, ticket))
      assert html_response(conn, 200) =~ "Edit Ticket"
    end
  end

  describe "update ticket" do
    setup [:create_ticket]

    test "redirects when data is valid", %{conn: conn, ticket: ticket} do
      conn = put(conn, Routes.ticket_path(conn, :update, ticket), ticket: @update_attrs)
      assert redirected_to(conn) == Routes.ticket_path(conn, :show, ticket)

      conn = get(conn, Routes.ticket_path(conn, :show, ticket))
      assert html_response(conn, 200) =~ "some updated client_token"
    end

    test "renders errors when data is invalid", %{conn: conn, ticket: ticket} do
      conn = put(conn, Routes.ticket_path(conn, :update, ticket), ticket: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Ticket"
    end
  end

  describe "delete ticket" do
    setup [:create_ticket]

    test "deletes chosen ticket", %{conn: conn, ticket: ticket} do
      conn = delete(conn, Routes.ticket_path(conn, :delete, ticket))
      assert redirected_to(conn) == Routes.ticket_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.ticket_path(conn, :show, ticket))
      end
    end
  end

  defp create_ticket(_) do
    ticket = fixture(:ticket)
    {:ok, ticket: ticket}
  end
end
