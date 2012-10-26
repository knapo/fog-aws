require 'fog/core/model'
require 'fog/hp/models/storage/shared_files'

module Fog
  module Storage
    class HP

      class SharedDirectory < Fog::Model

        identity  :url

        attribute :bytes, :aliases => 'X-Container-Bytes-Used'
        attribute :count, :aliases => 'X-Container-Object-Count'

        def files
          @files ||= begin
            Fog::Storage::HP::SharedFiles.new(
              :shared_directory    => self,
              :connection          => connection
            )
          end
        end

        def destroy
          requires :url
          # delete is not allowed
          false
        end

        def save(options = {})
          requires :url
          data = connection.put_shared_container(url, options)
          merge_attributes(data.headers)
          true
        rescue Fog::Storage::HP::NotFound, Fog::HP::Errors::Forbidden
          false
        end
      end

    end
  end
end
