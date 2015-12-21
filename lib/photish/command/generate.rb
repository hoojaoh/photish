module Photish
  module Command
    class Generate < Base
      def run
        load_all_plugins
        render_whole_site
        log.info 'Site generation completed successfully'
      end

      private

      delegate :output_dir,
               :site_dir,
               :photo_dir,
               :qualities,
               :templates,
               :url,
               :max_workers,
               to: :config

      def load_all_plugins
        Photish::Plugin::Repository.reload(log, site_dir)
      end

      def render_whole_site
        Photish::Render::Site.new(templates,
                                  site_dir,
                                  output_dir,
                                  max_workers,
                                  version_hash)
                             .all_for(collection)
      end

      def collection
        @collection ||= Gallery::Collection.new(photo_dir,
                                                qualities_mapped,
                                                url)
      end

      def qualities_mapped
        qualities.map { |quality| OpenStruct.new(quality) }
      end
    end
  end
end
