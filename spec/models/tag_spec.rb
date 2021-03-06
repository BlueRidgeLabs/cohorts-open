# frozen_string_literal: true
require 'rails_helper'

describe Tag do
  subject { FactoryGirl.create(:tag) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }

  it 'should update counter_cache' do
    expect(subject).to be_valid
    expect(subject.taggings_count).to eq(0)

    person = FactoryGirl.create(:person)
    user   = FactoryGirl.create(:user)

    @tag = Tag.find_or_initialize_by(name: subject.name)
    @tag.created_by ||= user.id
    expect(subject.taggings_count).to eq(0)
    @tagging = Tagging.new(taggable_type: person.class.to_s,
                          taggable_id: person.id,
                          tag: subject)
    @tagging.with_user(user).save!

    subject.reload
    expect(subject.taggings_count).to eq(1)
  end

  it 'should delete unused tags' do
    person = FactoryGirl.create(:person)
    user   = FactoryGirl.create(:user)

    @tag = Tag.find_or_initialize_by(name: subject.name)
    @tag.created_by ||= user.id
    @tagging = Tagging.new(taggable_type: person.class.to_s,
                            taggable_id: person.id,
                            tag: subject)

    @tagging.with_user(user).save

    expect(subject.taggings_count).to eq(1)

    @tagging.destroy

    # the tag shouldn't exist
    expect { Tag.find(subject.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'should not create empty tags' do
    @tag = Tag.new(name: '')
    expect(@tag.save).to be_falsey
  end

  it 'should create tags with names' do
    @tag = Tag.new(name: 'TAG')
    expect(@tag.save).to be_truthy
  end
end
