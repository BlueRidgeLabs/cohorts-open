# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ExtrapolateAnswersJob, type: :job do
  job = ExtrapolateAnswersJob.new

  context 'add_to_options' do
    it 'Adds an option that does not exist already' do
      options = ['red']
      expect(job.add_to_options(options, 'blue')).to eq %w(red blue)
    end

    it 'Does not add an option that already exists' do
      options = ['red']
      expect(job.add_to_options(options, 'red')).to eq ['red']
    end
  end

  context 'map_race_or_ethnicity_option' do
    it 'Maps "Hispanic or Latino" correctly' do
      expect(job.map_race_or_ethnicity_option('Hispanic or Latino')).to eq 'Hispanic, Latino, or Spanish Origin'
    end

    it 'Maps other ethnicities correctly' do
      expect(job.map_race_or_ethnicity_option('Other')).to eq 'Other'
    end
  end

  context 'map_employment_option' do
    it 'Maps anything other than "Unemployed" and "Retired" correctly' do
      expect(job.map_employment_option('foo')).to eq 'Employed full-time (30+ hours/week)'
    end

    it 'Maps "Unemployed" properly' do
      expect(job.map_employment_option('Unemployed')).to eq 'Unemployed'
    end

    it 'Maps "Retired" properly' do
      expect(job.map_employment_option('Retired')).to eq 'Retired'
    end
  end

  context 'map_devices_option' do
    it 'Maps a Cell phone correctly' do
      expect(job.map_devices_option('Cell phone')).to eq 'Smartphone'
    end

    it 'Maps a Tablet correctly' do
      expect(job.map_devices_option('Tablet')).to eq 'Tablet'
    end

    it 'Maps a Personal laptop computer correctly' do
      expect(job.map_devices_option('Personal laptop computer')).to eq 'Personal computer'
    end

    it 'Maps a Personal desktop computer correctly' do
      expect(job.map_devices_option('Personal desktop computer')).to eq 'Personal computer'
    end

    it 'Maps a Library or public computer correctly' do
      expect(job.map_devices_option('Library or public computer')).to eq 'Public or shared computer'
    end

    it 'returns nil when there is no mapping' do
      expect(job.map_devices_option('ipad')).to eq nil
    end
  end
end
