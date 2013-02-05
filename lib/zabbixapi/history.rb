module Zabbix
  class ZabbixApi

    def get_history(itemids)

      message = {
        'method'    => 'history.get',
        'params'    => {
          'itemids'   => itemids,
          'limit'     => 1,
          'sortorder' => 'DESC',
          'sortfield' => 'clock',
          'output'    => 'extend'
        }
      }

      response = send_request(message)

      unless response.empty?
        result = response
      else
        result = nil
      end

      return result
    end

  end
end
