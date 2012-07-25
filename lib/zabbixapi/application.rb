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

    # Delete application and all related information by given application id.
    # === Returns
    # Integer:: Deleted application id
    def del_application(app_id)

      message = {
        'method' => 'application.delete',
        'params' => [ app_id ]
      }

      response = send_request(message)

      unless response.empty?
        return response['applicationids'][0].to_i
      else
        return nil
      end
    end

    # Check application exists by given host id and application name.
    # === Returns
    # Boolean:: true if application exists
    def app_exists?(host_id, app_name)

      message = {
        'method' => 'application.exists',
        'params' => [ {'hostid' => host_id, 'name' => app_name} ]
      }

      response = send_request(message)

      return response
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
