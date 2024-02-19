# frozen_string_literal: true

require "rails_helper"
require "json"

RSpec.describe "recommendation to indicator relationships", type: :request do
  let(:created_by) { FactoryBot.create(:user, :manager) }
  let(:updated_by) { FactoryBot.create(:user, :admin) }

  describe "get one recommendation/indicator relationship" do
    let!(:recommendation_indicator) { FactoryBot.create(:recommendation_indicator, created_by:, updated_by:) }
    it "returns the recommendation/indicator releationship requested" do
      get "/recommendation_indicators/#{recommendation_indicator.id}"

      expected_json =
        {"data" =>
          {
            "id" => recommendation_indicator.id.to_s,
            "type" => "recommendation_indicators",
            "attributes" =>
            {
              "created_at" => recommendation_indicator.created_at.in_time_zone.iso8601,
              "created_by_id" => recommendation_indicator.created_by.id,
              "updated_at" => recommendation_indicator.updated_at.in_time_zone.iso8601,
              "updated_by_id" => recommendation_indicator.updated_by.id,
              "recommendation_id" => recommendation_indicator.recommendation_id,
              "indicator_id" => recommendation_indicator.indicator_id
            }
          }}

      json = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(json).to eq(expected_json)
    end
  end

  describe "get all the recommendation/indicator relationships in descending order" do
    let(:recommendation_1) { FactoryBot.create(:recommendation) }
    let(:recommendation_2) { FactoryBot.create(:recommendation) }
    let(:indicator_1) { FactoryBot.create(:indicator) }
    let(:indicator_2) { FactoryBot.create(:indicator) }
    let!(:recommendation_indicator_1) { FactoryBot.create(:recommendation_indicator, recommendation_id: recommendation_1.id, indicator_id: indicator_1.id, created_by:, updated_by:) }
    let!(:recommendation_indicator_2) { FactoryBot.create(:recommendation_indicator, recommendation_id: recommendation_1.id, indicator_id: indicator_2.id, created_by:, updated_by:) }
    let!(:recommendation_indicator_3) { FactoryBot.create(:recommendation_indicator, recommendation_id: recommendation_2.id, indicator_id: indicator_2.id, created_by:, updated_by:) }

    it "returns all the linkable recommendation/indicators" do
      get "/recommendation_indicators"

      expected_json =
        {"data" =>
          [
            {
              "id" => recommendation_indicator_3.id.to_s,
              "type" => "recommendation_indicators",
              "attributes" =>
              {
                "created_at" => recommendation_indicator_3.created_at.in_time_zone.iso8601,
                "created_by_id" => recommendation_indicator_3.created_by.id,
                "updated_at" => recommendation_indicator_3.updated_at.in_time_zone.iso8601,
                "updated_by_id" => recommendation_indicator_3.updated_by.id,
                "recommendation_id" => recommendation_indicator_3.recommendation_id,
                "indicator_id" => recommendation_indicator_3.indicator_id
              }
            },
            {
              "id" => recommendation_indicator_2.id.to_s,
              "type" => "recommendation_indicators",
              "attributes" =>
              {
                "created_at" => recommendation_indicator_2.created_at.in_time_zone.iso8601,
                "created_by_id" => recommendation_indicator_2.created_by.id,
                "updated_at" => recommendation_indicator_2.updated_at.in_time_zone.iso8601,
                "updated_by_id" => recommendation_indicator_2.updated_by.id,
                "recommendation_id" => recommendation_indicator_2.recommendation_id,
                "indicator_id" => recommendation_indicator_2.indicator_id
              }
            },
            {
              "id" => recommendation_indicator_1.id.to_s,
              "type" => "recommendation_indicators",
              "attributes" =>
              {
                "created_at" => recommendation_indicator_1.created_at.in_time_zone.iso8601,
                "created_by_id" => recommendation_indicator_1.created_by.id,
                "updated_at" => recommendation_indicator_1.updated_at.in_time_zone.iso8601,
                "updated_by_id" => recommendation_indicator_1.updated_by.id,
                "recommendation_id" => recommendation_indicator_1.recommendation_id,
                "indicator_id" => recommendation_indicator_1.indicator_id
              }
            }
          ]}

      json = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(json).to eq(expected_json)
    end
  end
end
