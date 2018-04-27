defmodule MedialibraryWeb do
	@moduledoc """
	The entrypoint for defining your web interface, such
	as controllers, views, channels and so on.

	This can be used in your application as:

		use MedialibraryWeb, :controller
		use MedialibraryWeb, :view

	The definitions below will be executed for every view,
	controller, etc, so keep them short and clean, focused
	on imports, uses and aliases.

	Do NOT define functions inside the quoted expressions
	below. Instead, define any helper function in modules
	and import those modules here.
	"""

	def controller do
		quote do
		use Phoenix.Controller, namespace: MedialibraryWeb
		import Plug.Conn
		import MedialibraryWeb.Router.Helpers
		import MedialibraryWeb.Gettext
		end
	end

	def view do
		quote do
		use Phoenix.View, root: "lib/medialibrary_web/templates",
							namespace: MedialibraryWeb

		# Import convenience functions from controllers
		import Phoenix.Controller, only: [get_flash: 2, view_module: 1]

		# Use all HTML functionality (forms, tags, etc)
		use Phoenix.HTML

		import MedialibraryWeb.Router.Helpers
		import MedialibraryWeb.ErrorHelpers
		import MedialibraryWeb.Gettext
		end
	end

	def router do
		quote do
		use Phoenix.Router
		import Plug.Conn
		import Phoenix.Controller
		end
	end

	def channel do
		quote do
		use Phoenix.Channel
		import MedialibraryWeb.Gettext
		end
	end

	@doc """
	When used, dispatch to the appropriate controller/view/etc.
	"""
	defmacro __using__(which) when is_atom(which) do
		apply(__MODULE__, which, [])
	end
end