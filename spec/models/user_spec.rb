require 'spec_helper'

describe User do
  context 'when created' do
    let(:user) { User.create }
    it { user.rating.should equal(100.0)}
  end
end
