ExUnit.start()
Application.ensure_all_started(:bypass)
Application.ensure_all_started(:mox)

Mox.defmock(Medialibrary.HttpMock, for: Medialibrary.HttpBehavior)
