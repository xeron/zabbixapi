module Zabbix
  class ZabbixApi

    def login
      unless @auth_id
        auth_message = {
          'auth' => nil,
          'method' => 'user.login',
          'params' => {
            'user' => @api_user,
            'password' => @api_password
          }
        }

        begin
          @auth_id = do_request(auth_message)
        rescue ZabbixError => e
          raise Zabbix::AuthError.new(e.message)
        end
      end

      return @auth_id
    end

  end
end
