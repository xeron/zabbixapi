$:.unshift(File.dirname(__FILE__))
require 'spec_helper'

API_URL = "http://zabbix.local/api_jsonrpc.php"
API_LOGIN = "admin"
API_PASSWORD = "zabbix"

AUTHID = "a82039d56baba1f92311aa917af9939b"
HOSTID = 10050
APPID = 100500
APPNAME = "SNMP Items"

describe Zabbix::ZabbixApi do

  before(:each) do
    @zbx = Zabbix::ZabbixApi.new(API_URL, API_LOGIN, API_PASSWORD)

    # Auth used in every test
    auth_response = '{"jsonrpc":"2.0","result":"' + AUTHID + '","id":2}'
    stub_request(:post, API_URL).with(:body => /"method":"user\.login".*"user":"admin"/).to_return(:body => auth_response)
    stub_request(:post, API_URL).with(:body => /"user":"admin".*"method":"user\.login"/).to_return(:body => auth_response)
  end


  context "user" do
    it "should login with correct data" do
      @zbx.login.should eq(AUTHID)
    end

    it "should not login with wrong data" do
      auth_response = '{"jsonrpc":"2.0","error":{"code":-32602,"message":"Invalid params.","data":"Login name or password is incorrect"},"id":2}'
      stub_request(:post, API_URL).with(:body => /"method":"user\.login".*"user":"wrong_user"/).to_return(:body => auth_response)
      stub_request(:post, API_URL).with(:body => /"user":"wrong_user".*"method":"user\.login"/).to_return(:body => auth_response)

      api_login = "wrong_user"
      zbx = Zabbix::ZabbixApi.new(API_URL, api_login, API_PASSWORD)
      lambda {zbx.login}.should raise_error(Zabbix::AuthError)
    end
  end


  context "application" do
    it "should add application" do
      add_application_response = '{"jsonrpc":"2.0","result":{"applicationids":["' + APPID.to_s + '"]},"id":2}'
      stub_request(:post, API_URL).with(:body => /"method":"application\.create"/).to_return(:body => add_application_response)

      @zbx.add_app(HOSTID, APPNAME).should eq(APPID)
    end

    it "should delete application" do
      del_application_response = '{"jsonrpc":"2.0","result":{"applicationids":["' + APPID.to_s + '"]},"id":2}'
      stub_request(:post, API_URL).with(:body => /"method":"application\.delete"/).to_return(:body => del_application_response)

      @zbx.del_app(APPID).should eq(APPID)
    end

    it "should check application exists" do
      exists_application_response = '{"jsonrpc":"2.0","result":true,"id":2}'
      stub_request(:post, API_URL).with(:body => /"method":"application\.exists"/).to_return(:body => exists_application_response)

      @zbx.app_exists?(HOSTID, APPNAME).should eq(true)
    end

    it "should check application doesn't exist" do
      exists_application_response = '{"jsonrpc":"2.0","result":false,"id":2}'
      stub_request(:post, API_URL).with(:body => /"method":"application\.exists"/).to_return(:body => exists_application_response)

      @zbx.app_exists?(HOSTID, APPNAME).should eq(false)
    end

    it "should get application id" do
      get_application_id_response = '{"jsonrpc":"2.0","result":[{"hosts":[{"hostid":"' + HOSTID.to_s + '"}],"applicationid":"' + APPID.to_s + '","name":"' + APPNAME + '","templateid":"100100000000005","host":"192.168.3.1"}],"id":2}'
      stub_request(:post, API_URL).with(:body => /"method":"application\.get"/).to_return(:body => get_application_id_response)

      @zbx.get_app_id(HOSTID, APPNAME).should eq(APPID)
    end
  end


  context "item" do
    item_options = {
      "description" => "Free disk space on $1",
      "key_" => "vfs.fs.size[/home/aly/,free]",
      "hostid" => HOSTID,
      "applications" => [ APPID, APPID + 1 ]
    }

    it "should add item" do
      add_item_response = '{"jsonrpc":"2.0","result":{"itemids":["' + HOSTID.to_s + '"]},"id":2}'
      stub_request(:post, API_URL).with(:body => /"method":"item\.create"/).to_return(:body => add_item_response)

      @zbx.add_item(item_options).should eq(HOSTID)
    end
  end

end
