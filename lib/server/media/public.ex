defmodule Server.Media.Public do
  alias Plug.Upload

  @path "uploads"

  @mime ["image/png"]

  def upload(params, field, filename \\ nil)

  def upload(params, field, filename) when is_map(params) and is_list(field) do
    path = get_in(params, field) |> handle_upload(filename)

    if is_binary(path) || is_nil(path) do
      {:ok, put_in(params, field, path)}
    else
      path
    end
  end

  def upload(_params, _field, _filename), do: {:error, :unprocessable_entity}

  defp handle_upload(%Upload{} = upload, filename) do
    file_name =
      if filename do
        "#{filename}#{Path.extname(upload.filename)}"
      else
        upload.filename
      end

    with true <- Enum.member?(@mime, upload.content_type),
         :ok <- File.cp(upload.path, path(file_name)) do
      "/#{@path}/#{file_name}"
    else
      false -> {:error, :unprocessable_entity}
      _ -> nil
    end
  end

  defp handle_upload(path, _filename), do: path

  defp path(filename) do
    Path.join([:code.priv_dir(:server), "static", @path, Path.basename(filename)])
  end
end
