module FriendlyId
  module Scopes

    def self.extended(model_class)
      model_class.scope :friendly, ->{model_class.all} do
        def find(*args)
          id = args.first
          return super if args.count != 1 || id.unfriendly_id?
          find_by_friendly_id(id) or super
        end

        def exists?(conditions = :none)
          return super if conditions.unfriendly_id?
          exists_by_friendly_id?(conditions)
        end
      end
    end

    def find_by_friendly_id(id)
      where(friendly_id_config.query_field => id).first
    end

    def exists_by_friendly_id?(id)
      where(friendly_id_config.query_field => id).exists?
    end

  end
end