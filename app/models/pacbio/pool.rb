# frozen_string_literal: true

module Pacbio
  # Pool
  class Pool < ApplicationRecord

    belongs_to :tube
    has_many :libraries, class_name: 'Pacbio::Library', foreign_key: :pacbio_library_id

    validates :libraries, presence: true
    validates_with TagValidator
  end
end
