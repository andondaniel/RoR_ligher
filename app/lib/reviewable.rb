require 'active_support/concern'

module Reviewable
  extend ActiveSupport::Concern

  included do
    belongs_to :creator, class_name: "User"
    has_many   :reviews, as: :review_item
    has_many   :reviewers, through: :reviews, class_name: "User"

    if Rails.env == "staging"
      scope :active,    -> { verified }
    else
      scope :active,    -> { verified.approved }
    end
    scope :verified,    -> { where(verified: true) }
    scope :approved,    -> { where(approved: true) }
    scope :unapproved,  -> { where(approved: false) }
    scope :unverified,  -> { where(verified: false) }
    scope :flagged,   -> { where(flag: true) }
    scope :unflagged,   -> { where(flag: false) }
    scope :verified_and_unapproved, -> { verified.unapproved }
    scope :verified_unapproved_and_unflagged, -> { verified.unapproved.unflagged }


  end

  def active
    verified && approved
  end

end