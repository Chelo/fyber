require 'digest/sha1'
require_relative "../../app"
require_relative "../../helpers/utils"

describe "Utils" do
  describe "construc_url" do
    it "return url" do
      allow(self).to receive_message_chain(:settings, :api_endpoint).and_return("http://api.sponsorpay.com/feed/v1/offers")
      expect(construct_url("string", "hash")).to eq("http://api.sponsorpay.com/feed/v1/offers.json?string&hashkey=hash")
    end
  end

  describe "hashkey_calculation" do
    it "should create hashkey" do
      allow(self).to receive_message_chain(:settings, :api_key).and_return("apikey")
      res = Digest::SHA1.hexdigest "string&apikey"
      expect(hashkey_calculation("string")).to eq(res)
    end
  end

  describe "create_url" do
    it "return url to make call" do
      data = {
        value1: "value1",
        value2: "value2"
      }
      allow(self).to receive_message_chain(:settings, :api_endpoint).and_return("http://api.sponsorpay.com/feed/v1/offers")
      allow(self).to receive_message_chain(:settings, :api_key).and_return("apikey")
      expect(create_url(data)).to eq("http://api.sponsorpay.com/feed/v1/offers.json?value1=value1&value2=value2&hashkey=bf54d4a6b5a5e69480ed72187fa635ad6f6d6932")
    end
  end
end
