require 'active_admin/engine'

# ActiveAdmin::ResourceController inherits from InheritedResources::Base, which lives in the app/controllers of the
# inherited_resources engine and can only be autoloaded after the engine set up its paths. That is why the controller is
# patched in to_prepare (it also runs on every code reload) and not in an initializer.
ActiveAdmin::Engine.config.to_prepare do
  ActiveAdmin::ResourceController.class_eval do
    def build_resource
      get_resource_ivar || begin
        resource = build_new_resource
        resource = apply_decorations(resource)
        run_build_callbacks resource
        authorize_resource! resource

        set_resource_ivar resource
      end
    end

    def build_new_resource
      scoped_collection.send(
        method_for_build,
        *resource_params
      )
    end
  end
end
