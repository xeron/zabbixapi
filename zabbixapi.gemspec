$:.unshift(File.dirname(__FILE__) + '/lib')
require 'zabbixapi/version'

Gem::Specification.new do |s|
  s.version = Zabbix::VERSION
  s.name = 'zabbixapi'
  s.summary = 'Ruby module for work with zabbix api.'
  s.description = 'Ruby module for work with zabbix api.'

  s.authors = ['Eduard Snesarev', 'Ivan Larionov']
  s.email = ['verm666@gmail.com', 'xeron.oskom@gmail.com']
  s.homepage = 'https://github.com/xeron/zabbixapi'

  s.has_rdoc = true
  s.extra_rdoc_files = 'README.rdoc'

  s.add_dependency 'json'

  s.add_development_dependency 'webmock'
  s.add_development_dependency 'rspec'

  s.require_path = 'lib'
  s.files = %w(LICENSE README.rdoc) + Dir.glob('{lib,spec,examples}/**/*')
end
