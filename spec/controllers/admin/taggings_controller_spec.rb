# frozen_string_literal: true
RSpec.describe Admin::TaggingsController do
  describe 'POST create' do
    it 'creates tags with a tag name' do
      sign_in create(:user)
      params = {
        tagging: {
          taggable_type: 'Person',
          taggable_id: '113',
          name: 'waffles'
        },
        format: :js
      }
      post :create, params
      expect(Tagging.count).to eq 1
    end

    it 'does not create tags with empty names' do
      @request.env['HTTP_REFERER'] = 'http://test.com/sessions/new'
      sign_in create(:user)
      params = {
        tagging: {
          taggable_type: 'Person',
          taggable_id: '114',
          name: ''
        },
        format: :js
      }
      post :create, params
      expect(Tagging.count).to eq 0
    end
  end
end
