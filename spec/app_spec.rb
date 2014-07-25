require 'rack/test'
require 'webmock/rspec'
require_relative "../app"
require_relative "../helpers/utils"


describe "APP" do
  include Rack::Test::Methods
  include Utils

  def app
    Sinatra::Application
  end

  describe 'GET /' do
    it "should render the form" do
      get "/"
      response = last_response.body
      expect(response).to include("Please enter your params")
      expect(response).to include("Uid")
      expect(response).to include("pub0")
      expect(response).to include("Page")
    end
  end

  describe 'POST /' do
    context "success" do
      before :each do
        @params = {
          pub0: 1,
          uid: 1,
          page: 1
        }
        @fake_response = []
        expect(HTTParty).to receive(:get).and_return(@fake_response)
        expect(@fake_response).to receive(:headers).and_return({"X-Sponsorpay-Response-Signature" => "blah"})
        expect(Digest::SHA1).to receive(:hexdigest).twice.and_return("blah")
        expect(@fake_response).to receive(:code).and_return(200)
      end
      context "there are offers" do
        before do
          @response_body = {
            code: "OK",
            message: "OK",
            offers: [
              {
            title: "Tap Fish",
            thumbnail: {
            lowres: "http://cdn.sponsorpay.com/assets/1808/icon175x175- 2_square_60.png",
            hires: "http://cdn.sponsorpay.com/assets/1808/icon175x175- 2_square_175.png"
          },
            payout: "90"
          }
          ]
          }
        end
        it "should render the offers" do
          expect(@fake_response).to receive(:body).twice.and_return(@response_body.to_json)
          post "/", @params
          response =  last_response.body
          expect(response).to include("Offers")
          expect(response).to include("Tap Fish")
          expect(response).to include("90")
        end
      end

      context "there aren't offers" do
        before do
          @response_body = {
            code: "NO_CONTENT",
            message: "Successful request, but no offers are currently available for this user.",
            offers: []
          }
        end
        it "should render the no_offers page" do
          expect(@fake_response).to receive(:body).twice.and_return(@response_body.to_json)
          post "/", @params
          response =  last_response.body
          expect(response).to include("No offers")
        end
      end
    end 

    context "error" do
      before :each do
        @params = {
          pub0: 1,
          uid: 1,
          page: "string"
        }
        @response_body = {
          code: "ERROR_FROM_API",
          message: "This is an error from the api"
        }
      end
      it "should render errors" do
          fake_response = []
          expect(HTTParty).to receive(:get).and_return(fake_response)
          expect(fake_response).to receive(:body).twice.and_return(@response_body.to_json)
          expect(fake_response).to receive(:headers).and_return({"X-Sponsorpay-Response-Signature" => "blah"})
          expect(Digest::SHA1).to receive(:hexdigest).twice.and_return("blah")
          expect(fake_response).to receive(:code).and_return(400)
          post "/", @params
          response =  last_response.body
          expect(response).to include("This is an error from the api")
      end
    end
  end
end
