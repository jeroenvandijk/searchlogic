module BinaryLogic
  module Searchgasm
    module ActiveRecord
      module Associations
        module AssociationCollection
          def self.included(klass)
            klass.class_eval do
              include Protection
            end
          end
          
          def find_with_searchgasm(*args)
            options = args.extract_options!
            args << sanitize_options_with_searchgasm(options)
            find_without_searchgasm(*args)
          end
          
          def build_conditions(options = {}, &block)
            @reflection.klass.build_conditions(options.merge(:scope => scope(:find)[:conditions]), &block)
          end
        
          def build_search(options = {}, &block)
            @reflection.klass.build_search(options.merge(:scope => scope(:find)[:conditions]), &block)
          end
        end
      
        module HasManyAssociation
          def count_with_searchgasm(*args)
            column_name, options = @reflection.klass.send(:construct_count_options_from_args, *args)
            count_without_searchgasm(column_name, sanitize_options_with_searchgasm(options))
          end
        end
      end
    end
  end
end

ActiveRecord::Associations::AssociationCollection.send(:include, BinaryLogic::Searchgasm::ActiveRecord::Associations::AssociationCollection)

module ::ActiveRecord
  module Associations
    class AssociationCollection
      alias_method_chain :find, :searchgasm
    end
  end
end

ActiveRecord::Associations::HasManyAssociation.send(:include, BinaryLogic::Searchgasm::ActiveRecord::Associations::HasManyAssociation)

module ::ActiveRecord
  module Associations
    class HasManyAssociation
      alias_method_chain :count, :searchgasm
    end
  end
end