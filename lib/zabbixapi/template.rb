module Zabbix
  class ZabbixApi

    def add_template(template_options)

      template_default = {
        'host' => nil,
        'groups' => []
      }

      template_options['groups'].map! { |group_id| {'groupid' => group_id} }

      template = merge_opt(template_default, template_options)

      message = {
        'method' => 'template.create',
        'params' => template
      }

      response = send_request(message)

      unless response.empty?
        result = response['templateids'][0].to_i
      else
        result = nil
      end

      return result
    end

    def get_template_ids_by_host(host_id)

      message = {
        'method' => 'template.get',
        'params' => {
          'hostids' => [ host_id ]
        }
      }

      response = send_request(message)

      unless response.empty?
        result = []

        response.each_key do |template|
          result << template['templateid'].to_i
        end
      else
        result = nil
      end

      return result
    end

    def get_templates

      message = {
        'method' => 'template.get',
        'params' => {
          'extendoutput' => '0'
        }
      }

      response = send_request(message)

      unless response.empty?
        template_ids = response.keys
        result = {}

        template_ids.each do |template_id|
          template_name = response[template_id]['host']
          result[template_id] = template_name
        end
      else
        result = nil
      end

      return result
    end

    def get_template_id(template_name)

      message = {
        'method' => 'template.get',
        'params' => {
          'filter' => {
            'host' => template_name
          }
        }
      }

      response = send_request(message)

      unless response.empty?
        result = response.keys[0]
      else
        result = nil
      end

      return result
    end

    def link_templates_with_hosts(templates_id, hosts_id)

      message_templates_id = check_if_array(templates_id)
      message_hosts_id = check_if_array(hosts_id)

      message = {
        'method' => 'template.massAdd',
        'params' => {
          'hosts' => message_hosts_id,
          'templates' => message_templates_id
        }
      }

      response = send_request(message)

      unless response.empty?
        return response
      else
        return nil
      end
    end

    def unlink_templates_from_hosts(templates_id, hosts_id)

      message_templates_id = check_if_array(templates_id)
      message_hosts_id = check_if_array(hosts_id)

      message = {
        'method' => 'template.massRemove',
        'params' => {
          'hosts' => message_hosts_id,
          'templates' => message_templates_id,
          'force' => '1'
        }
      }

      response = send_request(message)

      unless response.empty?
        return response
      else
        return nil
      end
    end

    private

    def check_if_array(value)
      if value.is_a? Array
        return value
      else
        return [ value ]
      end
    end

  end
end
