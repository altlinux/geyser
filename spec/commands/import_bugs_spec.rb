# frozen_string_literal: true

require 'rails_helper'

describe ImportBugs do
   describe '#uri' do
      let(:url) { double }

      subject { described_class.new(url) }

      before { expect(subject).to receive(:url).and_return(url) }

      before { expect(URI).to receive(:parse).with(url) }
   end
end
