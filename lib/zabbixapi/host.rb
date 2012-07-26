module Zabbix
  class ZabbixApi

    def add_host(host_options)

      host_default = {
        'host' => nil,
        'port' => 10050,
        'status' => 0,
        'proxy_hostid' => 0,
        'interfaces' => [],
        'groups' => [],
        'templates' => [],
        'ipmi_authtype' => 0,
        'ipmi_privilege' => 0,
        'ipmi_username' => '',
        'ipmi_password' => ''
      }

      host_options['groups'].map! { |group_id| {'groupid' => group_id} }
      host_options['templates'].map! { |template_id| {'templateid' => template_id} }

      host = merge_opt(host_default, host_options)

      message = {
        'method' => 'host.create',
        'params' => host
      }

      response = send_request(message)

      unless response.empty?
        result = response['hostids'][0].to_i
      else
        result = nil
      end

      return result
    end

    def get_host_id(hostname)

      message = {
        'method' => 'host.get',
        'params' => {
          'filter' => {
            'host' => hostname
          }
        }
      }

      response = send_request(message)

      unless response.empty?
        result = response[0]['hostid'].to_i
      else
        result = nil
      end

      return result
    end

  end
end
