module Zabbix
  class ZabbixApi

    def add_macro(host_id, macro_name, macro_value)
      message = {
        'method' => 'Usermacro.massAdd',
        'params' => {
          'macros' => [{'macro' => macro_name, 'value' => macro_value}],
          'hosts'  => [{'hostid' => host_id}]
        }
      }

      macro_request(message)
    end

    def get_macro(host_id, macro_name)
      message = {
        'method' => 'Usermacro.get',
        'params' => {
          'hostids' => host_id,
          'filter' => {'macro' => macro_name},
          'extendoutput' => '1'
        }
      }

      response = send_request(message)

      unless response.empty?
        result = {
          'id' => response[0]['hostmacroid'].to_i,
          'value'=> response[0]['value']
        }
      else
        result = nil
      end

      return result
    end

    def set_macro_value(host_id, macro_name, macro_value)
      message = {
        'method' => 'usermacro.massUpdate',
        'params' => {
          'macros' => [{'macro' => macro_name, 'value' => macro_value}],
          'hosts'  => [{'hostid' => host_id}]
        }
      }

      macro_request(message)
    end

    private

    def macro_request(message)
      response = send_request(message)
      response.empty? ? nil : response['hostmacroids'].map { |id| id.to_i }
    end

  end
end
