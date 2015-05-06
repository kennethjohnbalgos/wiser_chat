require 'rails/generators/named_base'

module WiserChat
  module Generators
    module Base
      # Get path for migration template
      def source_root
        @_wiser_chat_source_root ||= File.expand_path(File.join('../wiser_chat', generator_name, 'templates'), __FILE__)
      end
    end
  end
end