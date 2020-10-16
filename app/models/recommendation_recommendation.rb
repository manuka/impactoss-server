class RecommendationRecommendation < ApplicationRecord
  self.table_name = "recommendations_recommendations"

  belongs_to :recommendation, :foreign_key => "recommendation_id", :class_name => "Recommendation"
  belongs_to :other_recommendation, :foreign_key => "other_recommendation_id", :class_name => "Recommendation"
end
