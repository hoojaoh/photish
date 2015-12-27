module Photish
  module Command
    class Deploy < Base
      def run
        load_all_plugins
        log.info "Requested engine: #{engine}"

        return no_engine_found unless engine && engine_class

        log.info "Regenerating site, to ensure fresh copy"
        regenerate_entire_site

        log.info "Deploying with engine #{engine_class}"
        engine_class.new(config, log).deploy_site
      end

      private

      delegate :engine,
               :site_dir,
               to: :config

      def regenerate_entire_site
        Photish::Command::Generate.new(runtime_config)
                                  .execute
      end

      def no_engine_found
        log.info "No engine found..."
      end

      def load_all_plugins
        Plugin::Repository.instance.reload(site_dir)
      end

      def engine_class
        @engine ||= deploy_plugins.find do |p|
          p.engine_name == engine
        end
      end

      def deploy_plugins
        Plugin::Repository.instance.plugins_for(deploy_plugin_type)
      end

      def deploy_plugin_type
        Plugin::Type::Deploy
      end
    end
  end
end
