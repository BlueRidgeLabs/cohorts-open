# frozen_string_literal: true
require 'rails_helper'

describe Tagging do
  it 'should not create Taggings with empty tag names' do
    @tag = Tag.create(name: '')
    @tagging = Tagging.create(taggable_type: 'Person', taggable_id: '1', tag: @tag)
    expect(Tagging.find_by(taggable_id: '1')).to be_nil
  end

  it 'should create a Tagging with a tag name' do
    @tag = Tag.create(name: 'tagged')
    @tagging = Tagging.create(taggable_type: 'Person', taggable_id: '2', tag: @tag)
    expect(Tagging.find_by(taggable_id: '2')).to eq(@tagging)
  end
end
