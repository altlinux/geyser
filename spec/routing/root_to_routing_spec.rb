# frozen_string_literal: true

require 'rails_helper'

describe 'root' do
   describe 'routing' do
      # get '/' => 'srpms#index'
      it do
         is_expected.to route(:get, '/')
                    .to("srpms#index")
      end
   end
end
