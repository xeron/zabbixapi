$:.unshift(File.dirname(__FILE__) + '/lib')
require 'zabbixapi/version'

Gem::Specification.new do |s|
  s.version = Zabbix::VERSION
  s.name = 'zabbixapi'
  s.summary = 'Ruby module for work with zabbix api.'
  s.email = ['verm666@gmail.com', 'xeron.oskom@gmail.com']
  s.authors = ['Eduard Snesarev', 'Ivan Larionov']
  s.homepage = 'https://github.com/xeron/zabbixapi'
  s.description = 'Ruby module for work with zabbix api.'

  s.has_rdoc = true
  s.extra_rdoc_files = 'README.rdoc'

  s.add_dependency "json"

  s.require_path = 'lib'
  s.files = %w(LICENSE README.rdoc) + Dir.glob("{lib,spec,examples}/**/*")
end
