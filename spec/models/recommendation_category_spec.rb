require "rails_helper"
require_relative "../shared_examples/enforce_allow_multiple"

RSpec.describe RecommendationCategory, type: :model do
  it { is_expected.to belong_to :recommendation }
  it { is_expected.to belong_to :category }
  it { is_expected.to validate_uniqueness_of(:category_id).scoped_to(:recommendation_id) }
  it { is_expected.to validate_presence_of(:recommendation_id) }
  it { is_expected.to validate_presence_of(:category_id) }

  context "with default fixtures" do
    let(:category) { FactoryBot.create(:category) }
    let(:recommendation) { FactoryBot.create(:recommendation) }
    let(:whodunnit) { FactoryBot.create(:user).id }

    subject { described_class.create(category: category, recommendation: recommendation) }

    before { allow(::PaperTrail.request).to receive(:whodunnit).and_return(whodunnit) }

    it "creates a valid record" do
      expect(subject).to be_valid
    end

    it "create sets the relationship_updated_at on the recommendation" do
      expect { subject }.to change { recommendation.reload.relationship_updated_at }
    end

    it "update sets the relationship_updated_at on the recommendation" do
      subject
      expect { subject.touch }.to change { recommendation.reload.relationship_updated_at }
    end

    it "destroy sets the relationship_updated_at on the recommendation" do
      expect { subject.destroy }.to change { recommendation.reload.relationship_updated_at }
    end

    it "create sets the relationship_updated_by_id on the recommendation" do
      expect { subject }.to change { recommendation.reload.relationship_updated_by_id }.to(whodunnit)
    end

    it "update sets the relationship_updated_by_id on the recommendation" do
      subject
      recommendation.update_column(:relationship_updated_by_id, nil)
      expect { subject.touch }.to change { recommendation.reload.relationship_updated_by_id }.to(whodunnit)
    end

    it "destroy sets the relationship_updated_by_id on the recommendation" do
      expect { subject.destroy }.to change { recommendation.reload.relationship_updated_by_id }.to(whodunnit)
    end
  end

  include_examples "save_with_cleanup enforces taxonomy.allow_multiple", {
    association: :recommendation,
    factory: :recommendation,
    name: "Recommendation",
    title: :title
  }
end
