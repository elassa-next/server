defmodule ServerWeb.V1.Student.SessionJSON do
  def create(%{user: user, token: token}) do
    %{
      data: %{
        user: %{
          id: user.id,
          username: user.username,
          name: user.name,
          email: user.email,
          phone: user.phone,
          image: user.image,
          confirmed_at: user.confirmed_at
        },
        access_token: token
      }
    }
  end
end
