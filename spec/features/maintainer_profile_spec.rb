# frozen_string_literal: true

require 'rails_helper'

include Warden::Test::Helpers

describe 'Maintainer profile' do
  before do
    create(:branch, name: 'Sisyphus', vendor: 'ALT Linux', slug: "sisyphus")
  end

  context 'user' do
    it 'should not see "edit my maintainer profile link"' do
      user = create(:user, :confirmed)

      login_as user

      visit '/'
      expect(page).not_to have_content('Edit my maintainer profile')
    end
  end

  context 'maintainer' do
    it 'should see "edit my maintainer profile link"' do
      user = create(:user, :confirmed, email: 'icesik@altlinux.org')
      login_as user

      visit '/'
      expect(page).to have_content('Edit my maintainer profile')
    end

    it 'should able update maintainer profile' do
      user = create(:user, :confirmed, email: 'icesik@altlinux.org')
      create(:maintainer, login: 'icesik', email: 'icesik@altlinux.org')
      login_as user

      visit '/'

      click_link 'Edit my maintainer profile'

      fill_in('Website/Blog:', with: 'http://biow0lf.pp.ua')
      fill_in('Location:', with: 'Ukraine')
      select('Europe - Kiev', from: 'Time Zone:')
      fill_in('Jabber ID:', with: 'icesik@jabber.ru')
      fill_in('Info:', with: 'king dead long live')

      click_button 'Update'

      expect(page).to have_content('http://biow0lf.pp.ua')
      expect(page).to have_content('Ukraine')
      expect(page).to have_content('Europe/Kiev')
      expect(page).to have_content('icesik@jabber.ru')
      expect(page).to have_content('king dead long live')
    end
  end
end
