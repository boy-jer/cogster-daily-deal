module WillPaginate
  module ViewHelpers
    module ActionView
      def paginated_section(*args, &block)
        pagination = will_paginate(*args).try(:to_s)
        if pagination
          pagination + capture(&block) + pagination
        else
          capture(&block)
        end
      end
      
    end
    
  end
  
end
