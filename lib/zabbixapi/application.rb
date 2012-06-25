module Zabbix
  class ZabbixApi

    # Add application to host by given host id and new application name.
    # === Returns
    # Integer:: New application id
    def add_application(host_id, app_name)

      message = {
        'method' => 'application.create',
        'params' => [ {'hostid' => host_id, 'name' => app_name} ]
      }

      response = send_request(message)

      unless response.empty?
        return response['applicationids'][0].to_i
      else
        return nil
      end
    end

    # Get id of application by given host id and application name.
    # === Returns
    # Integer:: Application id
    def get_application_id(host_id, app_name)

      message = {
        'method' => 'application.get',
        'params' => {
          'filter' => {
            'hostid' => host_id,
            'name' => app_name
          }
        }
      }

      response = send_request(message)

      unless response.empty?
        return response[0]['applicationid'].to_i
      else
        return nil
      end
    end

  end
end
