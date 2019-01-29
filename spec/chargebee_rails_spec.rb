require 'spec_helper'
require 'sample_class'

describe "chargebee_rails" do
  
  describe "#as_chargebee_customer" do
    let(:cb_id) { 'IG5ryicPgRSUWg1O0h' }


    it 'returns its corresponding Chargebee customer object' do
      # Test our library
      user = User.new
      user.chargebee_id = cb_id

      cb_customer = user.as_chargebee_customer
      actual_id = cb_customer.id

      # Compare to direct ChargeBee API result
      customer = ChargeBee::Customer.retrieve(cb_id).customer
      expected_id = customer.id

      expect(cb_customer).to be_a(ChargeBee::Customer)
      expect(actual_id).to eq(expected_id)
    end
  end

  describe "#configuration" do
    it 'should configure the default values for the application' do
      ChargebeeRails.configuration.default_plan_id.should be_nil
      ChargebeeRails.configuration.end_of_term.should be false
      ChargebeeRails.configuration.include_delayed_charges[:changes_estimate].should be false
      ChargebeeRails.configuration.include_delayed_charges[:renewal_estimate].should be true
      ChargebeeRails.configuration.webhook_api_path.should eq 'chargebee_rails_event'
      ChargebeeRails.configuration.secure_webhook_api.should be false
      ChargebeeRails.configuration.webhook_authentication[:user].should be nil
      ChargebeeRails.configuration.webhook_authentication[:secret].should be nil
      ChargebeeRails.configuration.chargebee_site.should be nil
      ChargebeeRails.configuration.chargebee_api_key.should be nil
      ChargebeeRails.configure do |config|
        config.default_plan_id = "sample_plan_id"
        config.end_of_term = true
        config.include_delayed_charges = {changes_estimate: true, renewal_estimate: false }
        config.webhook_api_path = 'webhook_events'
        config.secure_webhook_api = true
        config.webhook_authentication = {user: "test_user", secret: "test_pass"}
        config.chargebee_site = "dummy-site"
        config.chargebee_api_key = "dummy-api-key"
      end
      expect(ChargebeeRails.configuration.default_plan_id).to eq("sample_plan_id")
      expect(ChargebeeRails.configuration.end_of_term).to be true
      expect(ChargebeeRails.configuration.include_delayed_charges[:changes_estimate]).to be true
      expect(ChargebeeRails.configuration.include_delayed_charges[:renewal_estimate]).to be false
      expect(ChargebeeRails.configuration.webhook_api_path).to eq 'webhook_events'
      expect(ChargebeeRails.configuration.secure_webhook_api).to be true
      expect(ChargebeeRails.configuration.webhook_authentication[:user]).to eq 'test_user'
      expect(ChargebeeRails.configuration.webhook_authentication[:secret]).to eq 'test_pass'
      expect(ChargebeeRails.configuration.chargebee_site).to eq 'dummy-site'
      expect(ChargebeeRails.configuration.chargebee_api_key).to eq 'dummy-api-key'
    end
  end
end
