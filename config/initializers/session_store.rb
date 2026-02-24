# Explicit expiry so session cookie persists across WKWebView app restarts
Rails.application.config.session_store :cookie_store,
  key: '_finex_session',
  expire_after: 6.months
