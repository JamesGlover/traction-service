# frozen_string_literal: true

module Ont
  # Ont::Run
  class Run < ApplicationRecord
    include Stateful

    has_many :flowcells, foreign_key: :ont_run_id, inverse_of: :run, dependent: :destroy

    scope :active, -> { where(deactivated_at: nil) }

    def active?
      deactivated_at.nil?
    end

    def cancel
      return true unless active?

      update(deactivated_at: DateTime.current)
    end

    def experiment_name
      "ONTRUN-#{id}"
    end

    # Make table read only. We don't want anything pushing to it.
    def readonly?
      true
    end
  end
end
