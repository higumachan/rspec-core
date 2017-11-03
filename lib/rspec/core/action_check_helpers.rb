
module RSpec
  module Core
    module ActionCheckHelpers
      module ClassMethods
        def __before_action_name
          :root
        end
        def __action_dags
          {}
        end

        def create_from_dag(node)
          Proc.new do ||
            node[:forwards].each do |next_node_name|
            next_node = __action_dags[next_node_name]
            context next_node[:action][:description] do
              before(&next_node[:action][:block])
              next_node[:examples].each do |example_info|
                example("check:#{example_info[:description]}", &example_info[:block])
              end
              context_proc = create_from_dag(next_node)
              self.module_exec(&context_proc) if context_proc
            end
          end
          end
        end

        def actions(description, &actions_block)
          context description do
            before_action_name = __before_action_name
            self.module_exec(&actions_block)
            if __action_dags.empty?
              pending 'actions is empty'
              return
            end
            node = __action_dags[before_action_name]

            self.module_exec(&create_from_dag(node))
          end
        end

        def branch(description, &branch_block)
          name = "#{description.gsub(/ /, "_")}_#{__action_dags.size}".to_sym
          before_action_name = __before_action_name

          _update_action_dags(name, description, before_action_name, Proc.new{})

          context do
            _update_before_action_name(name)
            self.module_exec(&branch_block)
          end
        end

        def action(description, &action_block)
          before_action_name = __before_action_name
          name = "#{description.gsub(/ /, "_")}_#{__action_dags.size}".to_sym

          _update_before_action_name(name)

          _update_action_dags(name, description, before_action_name, action_block)
        end

        def check(description, &action_block)
          check_action_name =  __before_action_name

          _action_dags = __action_dags
          _action_dags[check_action_name][:examples] << {
            description: description,
            block: action_block,
          }
          idempotently_define_singleton_method(:__action_dags) do ||
            _action_dags
          end
        end

        def _update_action_dags(name, action_description, before_action_name, action_block)
          _action_dags = __action_dags
          _action_dags[name] = {
            forwards: [],
            backwards: [],
            examples: [],
          } if _action_dags[name].nil?
          _action_dags[before_action_name] = {
            forwards: [],
            backwards: [],
            examples: [],
          } if _action_dags[before_action_name].nil?
          _action_dags[name].merge!({
            forwards: _action_dags[name][:forwards],
            backwards: _action_dags[name][:backwards] | [before_action_name],
            action: {description: "action:#{description}", block: action_block},
          })
          _action_dags[before_action_name].merge!({
            forwards: _action_dags[before_action_name][:forwards] | [name],
            backwards: _action_dags[before_action_name][:backwards],
          })
          idempotently_define_singleton_method(:__action_dags) do ||
            _action_dags
          end
        end

        def _update_before_action_name(name)
          idempotently_define_singleton_method(:__before_action_name) do ||
            name
          end

        end
      end
    end
  end
end
