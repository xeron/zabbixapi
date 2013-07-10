module Zabbix
  class ZabbixApi

    # Create group by given group name.
    # === Returns
    # String:: New group id
    def add_group(group_name)
      message = {
        'method' => 'hostgroup.create',
        'params' => {
          'name' => group_name
        }
      }

      group_request(message)
    end

    # Delete group by given group id.
    # === Returns
    # String:: Deleted group id
    def del_group(group_id)
      message = {
        'method' => 'hostgroup.delete',
        'params' => {
          'groupid' => group_id
        }
      }

      group_request(message)
    end

    # Check group exists by given group name.
    # === Returns
    # Boolean:: true if group exists
    def group_exist?(group_name)
      get_group_id(group_name) ? true : false
    end
    alias group_exists? group_exist?

    # Get id of group by given group name.
    # === Returns
    # String:: Group id
    def get_group_id(group_name)
      message = {
        'method' => 'hostgroup.get',
        'params' => {
          'filter' => {
            'name' => group_name
          }
        }
      }

      response = send_request(message)
      response.empty? ? nil : response[0]['groupid']
    end

    # Add host to group by given host id and group id.
    # === Returns
    # String:: Group id
    def add_host_to_group(host_id, group_id)
      message = {
        'method' => 'hostgroup.massAdd',
        'params' => {
          'groups' => [ {'groupid' => group_id} ],
          'hosts' => [ {'hostid' => host_id} ]
        }
      }

      group_request(message)
    end

    private

    def group_request(message)
      response = send_request(message)
      response.empty? ? nil : response['groupids'][0]
    end

  end
end
