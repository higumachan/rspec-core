
module RSpec
  module Core
    module ActionCheckHelpers
      module ClassMethods
        def __actions
          {}
        end
        def __before_action
          nil
        end

        def action(name, description, before_action_name=nil, &action_block)
          before_action = (not before_action_name.nil?) ? __actions[before_action_name] : (__before_action || self)

          thread_data = RSpec::Support.thread_local_data
          top_level = self == ExampleGroup

          registration_collection =
            if top_level
              if thread_data[:in_example_group]
                raise "Creating an isolated context from within a context is " \
                      "not allowed. Change `RSpec.#{name}` to `#{name}` or " \
                      "move this to a top-level scope."
              end

              thread_data[:in_example_group] = true
              RSpec.world.example_groups
            else
              children
            end
          context = self.subclass(before_action, description, [], registration_collection)
          context.before(&action_block)

          actions = __actions
          idempotently_define_singleton_method(:__actions) do ||
            actions[name] = context
            actions
          end
          idempotently_define_singleton_method(:__before_action) do ||
            context
          end


          RSpec::Support.thread_local_data[:__before_action] = context
          RSpec::Support.thread_local_data[:__actions] = {} if RSpec::Support.thread_local_data[:__actions].nil?
          RSpec::Support.thread_local_data[:__actions][name] = context
        end

        def check(description, checked_action_name=nil, &action_block)
          check_action =  (not checked_action_name.nil?) ? __actions[checked_action_name] : __before_action

          RSpec::Core::Example.new(check_action, description, {}, action_block)
        end
      end
    end
  end
end
