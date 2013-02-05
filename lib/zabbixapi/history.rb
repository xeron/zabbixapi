module Zabbix
  class ZabbixApi

    TYPE_MAP = { String => '1', Integer => '3', Float => '0' }

    def get_history(itemids, type = Integer)

      message = {
        'method'    => 'history.get',
        'params'    => {
          'itemids'   => itemids,
          'limit'     => 1,
          'sortorder' => 'DESC',
          'sortfield' => 'clock',
          'output'    => 'extend',
          'history'   => TYPE_MAP[type]
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
