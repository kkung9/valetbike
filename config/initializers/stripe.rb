Rails.configuration.stripe = {
  :publishable_key => ENV['pk_test_51Mu2DBDRwtZV86Umj3yAaaqr5cMuaAm1ZGbLOcjJrT6kWvyzykJP4sikHMT0bE5mfXwtq2L1Z0bKljLzVLf9byIA00DlXV7Omp'],
  :secret_key      => ENV["sk_test_51Mu2DBDRwtZV86UmlnkSnDPMTt4IJkdbjH4Z8z2T7ewCMZyJuvRkDKIcRAKVKwiRxE1nFBoSKBlR8gma2Q5vPfyA003IWwpvvP"]
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]