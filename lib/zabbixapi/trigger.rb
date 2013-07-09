module Zabbix
  class ZabbixApi

    def add_trigger(trigger)
      message_trigger = check_if_array(trigger)
      message = {
        'method' => 'trigger.create',
        'params' => message_trigger
      }

      trigger_request(message)
    end
    alias add_triggers add_trigger

    def update_trigger(trigger)
      message_trigger = check_if_array(trigger)
      message = {
        'method' => 'trigger.update',
        'params' => message_trigger
      }

      trigger_request(message)
    end
    alias update_triggers update_trigger

    def delete_trigger(triggerid)
      message_triggerid = check_if_array(triggerid)
      message = {
          'method' => 'trigger.delete',
          'params' => message_triggerid
      }

      trigger_request(message)
    end
    alias delete_triggers delete_trigger

    def get_trigger_id(host_id, trigger_name)
      message = {
        'method' => 'trigger.get',
        'params' => {
          'filter' => {
            'hostid' => host_id,
            'description' => trigger_name
          }
        }
      }

      response = send_request(message)
      response.empty? ? nil : response[0]['triggerid'].to_i
    end

    def get_triggers_by_host(host_id)
      message = {
        'method' => 'trigger.get',
        'params' => {
          'filter' => {
            'hostid' => host_id,
          },
          'extendoutput' => '1'
        }
      }

      response = send_request(message)

      unless response.empty?
        result = {}

        response.each do |trigger|
          trigger_id = trigger['triggerid'].to_i
          description = trigger['description']
          result[trigger_id] = description
        end
      else
        result = {}
      end

      return result
    end

    # Requires a patch for zabbix web
    # https://support.zabbix.com/browse/ZBX-4046
    def get_triggers_by_application(host_id, app_id)
      message = {
        'method' => 'trigger.get',
        'params' => {
          'hostids' => [host_id],
          'applicationids' => [app_id],
          'select_functions' => 'extend',
          'select_items' => 'extend',
          'select_dependencies' => 'refer',
          'extendoutput' => '1',
          'expandDescription' => 1
        }
      }

      result = send_request(message)
      return result.is_a?(Hash) ? result.values : result
    end

    def update_trigger_status(trigger_id, status)
      message = {
        'method' => 'trigger.update_status',
        'params' => {
          'triggerid' => trigger_id,
          'status' => status
        }
      }

      response = send_request(message)
      response.empty? ? nil : response['triggerids'][0].to_i
    end

    def trigger_add_dependencies(dependencies)
      message = {
        'method' => 'trigger.adddependencies',
        'params' => dependencies
      }

      return send_request(message)
    end

    def trigger_delete_dependencies(dependencies)
      message = {
        'method' => 'trigger.deletedependencies',
        'params' => dependencies
      }

      return send_request(message)
    end

    private

    def trigger_request(message)
      response = send_request(message)
      response.empty? ? nil : response['triggerids'].map { |id| id.to_i }
    end

  end
end
