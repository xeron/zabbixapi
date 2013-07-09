module Zabbix
  class ZabbixApi

    def add_graph(graph)
      message = {
        'method' => 'graph.create',
        'params' => graph
      }

      graph_request(message)
    end
    alias add_graphs add_graph

    def update_graph(graph)
      message = {
        'method' => 'graph.update',
        'params' => graph
      }

      graph_request(message)
    end
    alias update_graphs update_graph

    def delete_graph(graphid)
      message_graphids = check_if_array(graphid)
      message = {
        'method' => 'graph.delete',
        'params' => message_graphids
      }

      graph_request(message)
    end
    alias delete_graphs delete_graph

    def get_graph_id(host_id, graph_name)
      message = {
        'method' => 'graph.get',
        'params' => {
          'filter' => {
            'name' => graph_name,
            'hostid' => host_id
          }
        }
      }

      response = send_request(message)
      response.empty? ? nil : response[0]['graphid'].to_i
    end

    def get_graphs(host_id)
      message = {
        'method' => 'graph.get',
        'params' => {
          'extendoutput' => '1',
          'filter' => {
            'hostid' => host_id
          }
        }
      }

      response = send_request(message)

      unless response.empty?
        result = {}

        response.each do |graph|
          graph_id = graph['graphid'].to_i
          graph_name = graph['name']

          result[graph_id] = graph_name
        end
      else
        result = nil
      end

      return result
    end

    def get_graphs_by_id(graph_ids)
      if graph_ids.empty?
        return []
      else
        message = {
          'method' => 'graph.get',
          'params' => {
            'extendoutput' => '1',
            'graphids' => graph_ids
          }
        }

        graph_info = send_request(message)

        message = {
          'method' => 'graphitem.get',
          'params' => {
            'extendoutput' => '1',
            'graphids' => graph_ids
          }
        }

        item_info = send_request(message)

        item_info.each do |item|
          graph_info.each do |graph|
            if graph['graphid'] == item['graphs'][0]['graphid']
              graph['gitems'] ||= []
              graph['gitems'] << item
            end
          end
        end

        return graph_info
      end
    end

    private

    def graph_request(message)
      response = send_request(message)
      response.empty? ? nil : response['graphids'].map { |id| id.to_i }
    end

  end
end
