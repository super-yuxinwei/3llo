require "spec_helper"

describe Tr3llo::RemoteServer, type: :http_request do
  let(:client) { described_class.new("http://localhost:8080") }

  describe ".get" do
    it "makes a GET request to the remote server" do
      payload = client.get("/get?foo=bar", {"Accept" => "text/plain"})

      expect(payload["args"]).to eq({"foo" => "bar"})
      expect(payload["headers"]).to include({"Accept" => "text/plain"})
    end
  end

  describe ".post" do
    it "makes a POST request to the remote server" do
      payload =
        client.post(
          "/post?abc=xyz",
          {"Accept" => "text/plain", "Content-type" => "application/json"},
          {"foo" => "bar"}
        )

      expect(payload["args"]).to eq({"abc" => "xyz"})
      expect(payload["data"]).to eq(JSON.dump({"foo" => "bar"}))
      expect(payload["headers"]).to include({"Accept" => "text/plain"})
    end
  end

  describe ".put" do
    it "makes a PUT request to the remote server" do
      payload =
        client.put(
          "/put?abc=xyz",
          {"Accept" => "text/plain", "Content-type" => "application/json"},
          {"foo" => "bar"}
        )

      expect(payload["args"]).to eq({"abc" => "xyz"})
      expect(payload["data"]).to eq(JSON.dump({"foo" => "bar"}))
      expect(payload["headers"]).to include({"Accept" => "text/plain"})
    end
  end
end
