# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def menu_item(title,controller,action="index",main=true)
    id = "menu-active" if controller_name == controller and main
    id = "submenu-active" if controller_name == controller and action_name == action and !main
    content_tag(:li, link_to(content_tag(:span, title), :controller => controller, :action => action), :id => id)
  end
  
  # http://garbageburrito.com/blog/entry/447/rails-super-cool-simple-column-sorting
  def sort_link(title, column, options = {})
    condition = options[:unless] if options.has_key?(:unless)
    if params[:c] == column.to_s
      sort_dir = params[:d] == 'up' ? 'down' : 'up'
    else
      sort_dir = 'up'
    end
    link = params[:c] == column.to_s ? "#{title} #{arrow}" : "#{title}"
    link_to_unless condition, "#{link}", request.parameters.merge( {:c => column, :d => sort_dir, :page => '1'} )
  end
  
  def arrow 
    params[:d] == "down" ? "&#8595;" : "&#8593;"
  end
  
  # http://github.com/mislav/will_paginate/issues/#issue/10
  def page_entries_info(collection, options = {})
    collection_size = collection.size
    entry_name = options[:entry_name] || begin
      if collection.empty?
        I18n.translate(:"will_paginate.entry", :default => "entry")
      else
        collection.first.class.human_name(:count => collection_size)
      end
    end

    if collection.total_pages < 2
      case collection.size
      when 0 then I18n.translate("will_paginate.found.zero", :entry_name => entry_name, :size => collection_size, :default => "No #{entry_name} found")
      when 1 then I18n.translate("will_paginate.found.one", :entry_name => entry_name, :size => collection_size, :default => "Displaying <b>1</b> #{entry_name}")
      else I18n.translate("will_paginate.found.other", :entry_name => entry_name, :size => collection_size, :default => "Displaying <b>all #{collection_size}</b> #{entry_name}")
      end
    else
      collection_from = collection.offset + 1
      collection_to = collection.offset + collection.length
      collection_total = collection.total_entries
      I18n.translate("will_paginate.display",
        :entry_name => entry_name,
        :from => collection_from,
        :to => collection_to,
        :total => collection_total,
        :default => "Displaying #{entry_name.pluralize} <b>#{collection_from}&nbsp;-&nbsp;#{collection_to}</b> of <b>#{collection_total}</b> in total"
      )
    end
  end
  
end
