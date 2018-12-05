# frozen_string_literal: true

require 'rails_helper'

describe PagesController do
   include RSpec::Rails::RequestExampleGroup

   describe 'routing' do
      it do
         is_expected.to route(:get, '/ru/project')
                    .to("pages#project", locale: :ru)
      end

      it do
         get '/project'
         expect(response).to redirect_to("/ru/project")
      end
   end
end
