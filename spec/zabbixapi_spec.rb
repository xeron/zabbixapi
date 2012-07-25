$:.unshift(File.dirname(__FILE__))
require 'spec_helper'

describe Zabbix::ZabbixApi do

  before(:each) do
    @api_url = 'http://zabbix.local/api_jsonrpc.php'
    @api_login = 'admin'
    @api_password = 'zabbix'
    @zbx = Zabbix::ZabbixApi.new(@api_url, @api_login, @api_password)

    # Auth used in every test
    auth_response = '{"jsonrpc":"2.0","result":"a82039d56baba1f92311aa917af9939b","id":83254}'
    stub_request(:post, @api_url).with(:body => /"method":"user\.login"/).to_return(:body => auth_response)
  end

  context 'user' do
    it 'should login with correct data' do
      @zbx.login.should_not be_nil
    end

    it 'should not login with wrong data' do
      auth_response = '{"jsonrpc":"2.0","error":{"code":-32602,"message":"Invalid params.","data":"Login name or password is incorrect"},"id":11219}'
      stub_request(:post, @api_url).with(:body => /"method":"user\.login".*"wrong_user"/).to_return(:body => auth_response)

      api_login = 'wrong_user'
      zbx = Zabbix::ZabbixApi.new(@api_url, api_login, @api_password)
      lambda {zbx.login}.should raise_error(Zabbix::AuthError)
    end
  end

  context "application" do
    it "should add application" do
      add_application_response = '{"jsonrpc":"2.0","result":{"applicationids":["100100000214797"]},"id":2}'
      stub_request(:post, @api_url).with(:body => /"method":"application\.create"/).to_return(:body => add_application_response)

      @zbx.add_application(100100000010048, 'SNMP Items').should eq(100100000214797)
    end

    it "shoult get application id" do
      get_application_id_response = '{"jsonrpc":"2.0","result":[{"hosts":[{"hostid":"100100000010097"}],"applicationid":"100100000000572","name":"Filesystem","templateid":"100100000000005","host":"192.168.3.1"}],"id":2}'
      stub_request(:post, @api_url).with(:body => /"method":"application\.get"/).to_return(:body => get_application_id_response)

      @zbx.get_application_id(100100000010097, 'Filesystem').should eq(100100000000572)
    end
  end

  context 'item' do
    item_options = {
      'description' => 'Free disk space on $1',
      'key_' => 'vfs.fs.size[/home/aly/,free]',
      'hostid' => '100100000010048',
      'applications' => [ 100100000000001, 100100000000002 ]
    }

    it 'should add item' do
      add_item_response = '{"jsonrpc":"2.0","result":{"itemids":["100100000214797"]},"id":2}'
      stub_request(:post, @api_url).with(:body => /"method":"item\.create"/).to_return(:body => add_item_response)

      @zbx.add_item(item_options).should eq(100100000214797)
    end
  end

end
