# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tag, type: :model do
  it 'is valid with all params' do
    expect(create(:tag, oligo: 'CGATCGAATAT', group_id: '1')).to be_valid
  end

  it 'is not valid without an oligo' do
    expect(build(:tag, oligo: nil)).not_to be_valid
  end

  it 'is not valid without a group id' do
    expect(build(:tag, group_id: nil)).not_to be_valid
  end

  it 'is not valid without a set name' do
    expect(build(:tag, tag_set_id: nil)).not_to be_valid
  end

  it 'delegates set name to tag set' do
    tag = build(:tag)
    expect(tag.tag_set_name).to eq(tag.tag_set.name)
  end

  it 'group id should be unique within set' do
    tag = create(:tag)
    expect(build(:tag, group_id: tag.group_id, tag_set_id: tag.tag_set_id)).not_to be_valid
  end

  it 'oligo should be unique within set' do
    tag = create(:tag)
    expect(build(:tag, oligo: tag.oligo, tag_set_id: tag.tag_set_id)).not_to be_valid
  end

  it 'can have no tag taggables' do
    tag = create(:tag_with_taggables, taggables_count: 0)
    expect(tag.tag_taggables).to be_empty
  end

  it 'can have many tag taggables' do
    num_taggables = 3
    tag = create(:tag_with_taggables, taggables_count: num_taggables)
    expect(tag.tag_taggables.count).to eq(num_taggables)
  end

  it 'on destroy destroys tag_taggables, not taggables' do
    num_taggables = 3
    tag = create(:tag_with_taggables, taggables_count: num_taggables)
    # sanity check
    expect(Pacbio::Request.all.count).to eq(num_taggables)
    # destroy the tag
    tag.destroy
    # test outcome
    expect(TagTaggable.all.count).to eq(0)
    expect(Pacbio::Request.all.count).to eq(num_taggables)
  end
end
