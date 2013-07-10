module Zabbix
  class ZabbixApi

    # Create host.
    # === Returns
    # String:: New host id
    # === Input parameter - hash with host options. Available keys:
    #   - host - hostname. Default: nil;
    #   - port - zabbix agent port. Default: 10050;
    #   - status - host status. 0 - monitored (default), 1 - not monitored;
    #   - useip - use ip or dns name for monitoring host. 0 - use dns name (default), 1 - use ip;
    #   - dns - host dns name. Used if useip is set to 0. Default: '';
    #   - ip - host ip address. Used if useip is set to 1. Default: '0.0.0.0';
    #   - proxy_hostid - host id of zabbix proxy (if necessary). Default: 0 (don't use proxy server);
    #   - groups - array of groups host belongs. Default: [].
    #   - useipmi - Use ipmi or not. Default: 0 (don't use ipmi);
    #   - ipmi_ip - Default: '';
    #   - ipmi_port - Default: 623;
    #   - ipmi_authtype - Default: 0;
    #   - ipmi_privilege - Default: 0;
    #   - ipmi_username - Default: '';
    #   - ipmi_password - Default: '';
    def add_host(host_options)
      host_defaults = {
        'host' => nil,
        'port' => 10050,
        'status' => 0,
        'useip' => 0,
        'dns' => '',
        'ip' => '0.0.0.0',
        'proxy_hostid' => 0,
        'groups' => [],
        'useipmi' => 0,
        'ipmi_ip' => '',
        'ipmi_port' => 623,
        'ipmi_authtype' => 0,
        'ipmi_privilege' => 0,
        'ipmi_username' => '',
        'ipmi_password' => ''
      }

      host = merge_opt(host_defaults, host_options)
      host['groups'].map! { |group_id| {'groupid' => group_id} }

      message = {
        'method' => 'host.create',
        'params' => host
      }

      host_request(message)
    end

    # Delete host by given host id.
    # === Returns
    # String:: Deleted host id
    def del_host(host_id)
      message = {
        'method' => 'host.delete',
        'params' => [ {'hostid' => host_id} ]
      }

      host_request(message)
    end

    # Check host exists by given hostname.
    # === Returns
    # Boolean:: true if host exists
    def host_exist?(hostname)
      get_host_id(hostname) ? true : false
    end
    alias host_exists? host_exist?

    # Get id of host by given hostname.
    # === Returns
    # String:: Host id
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
      response.empty? ? nil : response[0]['hostid']
    end

    private

    def host_request(message)
      response = send_request(message)
      response.empty? ? nil : response['hostids'][0]
    end

  end
end
