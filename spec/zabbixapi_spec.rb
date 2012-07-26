$:.unshift(File.dirname(__FILE__))
require 'spec_helper'

API_URL = "http://zabbix.local/api_jsonrpc.php"
API_LOGIN = "admin"
API_PASSWORD = "zabbix"

AUTHID = "a82039d56baba1f92311aa917af9939b"
HOSTID = 10050
APPID = 100500
APPNAME = "SNMP Items"
GROUPNAME = "Linux"
GROUPID = 105

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
    it "should create application" do
      add_app_response = '{"jsonrpc":"2.0","result":{"applicationids":["' + APPID.to_s + '"]},"id":2}'
      stub_request(:post, API_URL).with(:body => /"method":"application\.create"/).to_return(:body => add_app_response)

      @zbx.add_app(HOSTID, APPNAME).should eq(APPID)
    end

    it "should delete application" do
      del_app_response = '{"jsonrpc":"2.0","result":{"applicationids":["' + APPID.to_s + '"]},"id":2}'
      stub_request(:post, API_URL).with(:body => /"method":"application\.delete"/).to_return(:body => del_app_response)

      @zbx.del_app(APPID).should eq(APPID)
    end

    it "should get application id" do
      get_app_id_response = '{"jsonrpc":"2.0","result":[{"applicationid":"' + APPID.to_s + '"}],"id":2}'
      stub_request(:post, API_URL).with(:body => /"method":"application\.get"/).to_return(:body => get_app_id_response)

      @zbx.get_app_id(HOSTID, APPNAME).should eq(APPID)
    end
  end


  context "group" do
    it "should create group" do
      add_group_response = '{"jsonrpc":"2.0","result":{"groupids":["' + GROUPID.to_s + '"]},"id":2}'
      stub_request(:post, API_URL).with(:body => /"method":"hostgroup\.create"/).to_return(:body => add_group_response)

      @zbx.add_group(GROUPNAME).should eq(GROUPID)
    end

    it "should delete group" do
      del_group_response = '{"jsonrpc":"2.0","result":{"groupids":["' + GROUPID.to_s + '"]},"id":2}'
      stub_request(:post, API_URL).with(:body => /"method":"hostgroup\.delete"/).to_return(:body => del_group_response)

      @zbx.del_group(GROUPID).should eq(GROUPID)
    end

    it "should get group id" do
      get_group_id_response = '{"jsonrpc":"2.0","result":[{"groupid":"' + GROUPID.to_s + '"}],"id":2}'
      stub_request(:post, API_URL).with(:body => /"method":"hostgroup\.get"/).to_return(:body => get_group_id_response)

      @zbx.get_group_id(GROUPNAME).should eq(GROUPID)
    end

    it "should add host to group" do
      add_host_to_group_response = '{"jsonrpc":"2.0","result":{"groupids":["' + GROUPID.to_s + '"]},"id":2}'
      stub_request(:post, API_URL).with(:body => /"method":"hostgroup\.massAdd"/).to_return(:body => add_host_to_group_response)

      @zbx.add_host_to_group(HOSTID, GROUPID).should eq(GROUPID)
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
