$:.unshift(File.dirname(__FILE__))
require 'spec_helper'

describe Zabbix::ZabbixApi do

  before(:each) do
    @api_url = 'http://zabbix.local/api_jsonrpc.php'
    @api_login = 'admin'
    @api_password = 'zabbix'

    # Auth used in every test
    auth_response = '{"jsonrpc":"2.0","result":"a82039d56baba1f92311aa917af9939b","id":83254}'
    stub_request(:post, @api_url).with(:body => /"method":"user\.login"/).to_return(:body => auth_response)
  end

  context 'auth' do
    it 'should login with correct data' do
      zbx = Zabbix::ZabbixApi.new(@api_url, @api_login, @api_password)
      zbx.login.should_not be_nil
    end

    it 'should not login with wrong data' do
      auth_response = '{"jsonrpc":"2.0","error":{"code":-32602,"message":"Invalid params.","data":"Login name or password is incorrect"},"id":11219}'
      stub_request(:post, @api_url).with(:body => /"method":"user\.login".*"wrong_user"/).to_return(:body => auth_response)

      api_login = 'wrong_user'
      zbx = Zabbix::ZabbixApi.new(@api_url, api_login, @api_password)
      lambda {zbx.login}.should raise_error(Zabbix::AuthError)
    end
  end

  context 'add item' do
    item_options = {
      'description' => 'Description',
      'key_' => 'key[,avg1]',
      'hostid' => '10160',
      'applications' => [ 393 ],
      'history' => 7,
      'trends' => 30,
      'delay' => 60,
      'value_type' => 0
    }

    it 'should add item' do
      add_item_response = '{"jsonrpc":"2.0","result":{"itemids":["19541"]},"id":80163}'
      stub_request(:post, @api_url).with(:body => /"method":"item\.create"/).to_return(:body => add_item_response)

      zbx = Zabbix::ZabbixApi.new(@api_url, @api_login, @api_password)
      zbx.add_item(item_options).should eq('19541')
    end
  end

end
