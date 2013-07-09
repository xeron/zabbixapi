module Zabbix
  VERSION = "0.2.1"

  class ZabbixApi

    def api_version
      message = {
        'method' => 'apiinfo.version'
      }

      response = send_request(message)

      unless response.empty?
        return response
      else
        return nil
      end
    end

  end
end
