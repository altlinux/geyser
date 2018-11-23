# frozen_string_literal: true

require 'rails_helper'

describe GroupController do
   include RSpec::Rails::RequestExampleGroup

   describe 'routing' do
      it { is_expected.to route(:get, '/ru/packages').to("group#index", locale: :ru) }
      it { is_expected.to route(:get, '/ru/packages/slug').to("group#show", locale: :ru, slug: "slug") }
   end

   describe 'packages.a.o routing' do
      it do
         get '/ru/Sisyphus/packages/Engineering'
         expect(response).to redirect_to("/ru/sisyphus/packages/engineering")
      end

      it do
         get '/ru/Sisyphus/packages/System/X11'
         expect(response).to redirect_to("/ru/sisyphus/packages/system_x11")
      end

      it do
         get '/ru/Sisyphus/packages/System/Configuration/Boot_and_Init'
         expect(response).to redirect_to("/ru/sisyphus/packages/system_configuration_boot_and_init")
      end
   end

   describe 'sisyphus.ru routing' do
      it do
         get '/ru/packages'
         expect(response).to redirect_to("/ru/sisyphus/packages")
      end

      it do
         get '/ru/packages/Engineering'
         expect(response).to redirect_to("/ru/sisyphus/packages/engineering")
      end

      it do
         get '/ru/packages/System/X11'
         expect(response).to redirect_to("/ru/sisyphus/packages/system_x11")
      end

      it do
         get '/ru/packages/System/Configuration/Boot_and_Init'
         expect(response).to redirect_to("/ru/sisyphus/packages/system_configuration_boot_and_init")
      end
   end
end
