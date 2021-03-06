require "spec_helper"

describe "list cards", type: :integration do
  include IntegrationSpecHelper

  before { $application = build_container() }
  after { $application = nil }

  it "lists all cards that belong to the list" do
    list_id = "list:1"

    make_client_mock($application) do |client_mock|
      payload = [
        {
          "id" => "card:1",
          "name" => "Card 1",
          "desc" => "first card",
          "shortUrl" => "https://example.com/cards/1"
        },
        {
          "id" => "card:2",
          "name" => "Card 2",
          "desc" => "second card",
          "shortUrl" => "https://example.com/cards/2"
        }
      ]

      expect(client_mock).to(
        receive(:get)
        .with(
          req_path("/lists/#{list_id}/cards", members: "true", member_fields: "id,username"),
          {}
        )
        .and_return(payload)
      )
    end

    interface = make_interface($application)

    execute_command("list cards " + list_id)

    output_string = interface.output.string

    expect(output_string).to match("card:1")
    expect(output_string).to match("Card 1")
    expect(output_string).to match("card:2")
    expect(output_string).to match("Card 2")
  end
end
