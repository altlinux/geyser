require 'rails_helper'

describe HomeController do
  describe 'routing' do
    it 'should route / to home#index' do
      expect(get: '/').to route_to('home#index')
    end

    it 'should route /:locale to home#index' do
      expect(get: '/en').to route_to(
        controller: 'home',
        action: 'index',
        locale: 'en')
    end

    it 'should route /:locale/:branch/home to home#index' do
      expect(get: '/en/Sisyphus/home').to route_to(
        controller: 'home',
        action: 'index',
        branch: 'Sisyphus',
        locale: 'en')
    end

    it 'should route /:branch/people to home#maintainers_list' do
      expect(get: '/Sisyphus/people').to route_to(
        controller: 'home',
        action: 'maintainers_list',
        branch: 'Sisyphus')
    end

    it 'should route /:locale/:branch/people to home#maintainers_list' do
      expect(get: '/en/Sisyphus/people').to route_to(
        controller: 'home',
        action: 'maintainers_list',
        branch: 'Sisyphus',
        locale: 'en')
    end
  end
end
