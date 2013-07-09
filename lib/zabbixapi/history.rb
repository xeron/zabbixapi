module Zabbix
  class ZabbixApi

    TYPE_MAP = { String => '1', Integer => '3', Float => '0' }

    def get_history(itemids, type = Integer, limit = 1)
      message = {
        'method' => 'history.get',
        'params' => {
          'itemids' => itemids,
          'limit' => limit,
          'sortorder' => 'DESC',
          'sortfield' => 'clock',
          'output' => 'extend',
          'history' => TYPE_MAP[type]
        }
      }

      response = send_request(message)
      response.empty? ? nil : response
    end

  end
end
