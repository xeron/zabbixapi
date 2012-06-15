$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'zabbixapi'
require 'json'

require 'webmock/rspec'
include WebMock::API
