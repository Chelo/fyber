configure do
  set :data, {
    appid: 157,
    device_id: "2b6f0cc904d137be2e1730235f5664094b831186",
    locale: "de",
    ip: "109.235.143.113",
    offer_types: 112,
    os_version: 6.0
  }
  set :format, "json"
  set :api_key, ENV['API_KEY']
  set :api_endpoint, "http://api.sponsorpay.com/feed/v1/offers.json"
end
