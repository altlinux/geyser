# frozen_string_literal: true

require 'rails_helper'

describe SearchesController do
   describe 'routing' do
      it do
         is_expected.to route(:get, '/ru/search')
                    .to("searches#show", locale: :ru)
      end
   end
end
