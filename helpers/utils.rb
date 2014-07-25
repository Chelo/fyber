require 'digest/sha1'
require 'uri'
require 'httparty'
require 'json'

module Utils
  def create_url data
    string_for_url = data.sort.map{|k| k.join("=")}.join("&")
    hash_key = hashkey_calculation string_for_url
    string_encoded = URI.encode string_for_url
    construct_url(string_encoded, hash_key)
  end

  def hashkey_calculation string
    Digest::SHA1.hexdigest "#{string}&#{settings.api_key}"
  end

  def construct_url string_encoded, hash_key
    "#{settings.api_endpoint}?#{string_encoded}&hashkey=#{hash_key}"
  end

  def is_valid? response
    sign = response.headers['X-Sponsorpay-Response-Signature']
    my_sign = Digest::SHA1.hexdigest "#{response.body}#{settings.api_key}"

    sign == my_sign
  end
end
