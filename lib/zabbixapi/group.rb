module Zabbix
  class ZabbixApi

    # Create group by given group name.
    # === Returns
    # Integer:: New group id
    def add_group(group_name)

      message = {
        'method' => 'hostgroup.create',
        'params' => {
          'name' => group_name
        }
      }

      response = send_request(message)

      unless response.empty?
        return response['groupids'][0].to_i
      else
        return nil
      end
    end

    # Delete group by given group id.
    # === Returns
    # Integer:: Deleted group id
    def del_group(group_id)

      message = {
        'method' => 'hostgroup.delete',
        'params' => {
          'groupid' => group_id
        }
      }

      response = send_request(message)

      unless response.empty?
        return response['groupids'][0].to_i
      else
        return nil
      end
    end

    # Check group exists by given group name.
    # === Returns
    # Boolean:: true if group exists
    def group_exist?(group_name)

      group_id = get_group_id(group_name)

      if group_id
        return true
      else
        return false
      end
    end
    alias group_exists? group_exist?

    # Get id of group by given group name.
    # === Returns
    # Integer:: Group id
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

      unless response.empty?
        return response[0]['groupid'].to_i
      else
        return nil
      end
    end

    # Add host to group by given host id and group id.
    # === Returns
    # Integer:: Group id
    def add_host_to_group(host_id, group_id)

      message = {
        'method' => 'hostgroup.massAdd',
        'params' => {
          'groups' => [ {'groupid' => group_id} ],
          'hosts' => [ {'hostid' => host_id} ]
        }
      }

      response = send_request(message)

      unless response.empty?
        return response['groupids'][0].to_i
      else
        return nil
      end
    end

  end
end
