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
      response.empty? ? nil : response['templateids'][0]
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

        response.each do |template|
          result << template['templateid']
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
        result = {}

        response.each do |template|
          template_name = template['host']
          template_id = template['templateid']
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
      response.empty? ? nil : response[0]["templateid"]
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
      response.empty? ? nil : response
    end

    def unlink_templates_from_hosts(templates_id, hosts_id)
      message_templates_id = check_if_array(templates_id)
      message_hosts_id = check_if_array(hosts_id)

      message = {
        'method' => 'template.massRemove',
        'params' => {
          'hostids' => message_hosts_id,
          'templateids' => message_templates_id
        }
      }

      response = send_request(message)
      response.empty? ? nil : response["templateids"]
    end

  end
end
