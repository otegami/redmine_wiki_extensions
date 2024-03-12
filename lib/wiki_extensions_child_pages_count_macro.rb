# frozen_string_literal: true

# Redmine - project management software
# Copyright (C) 2006-  Jean-Philippe Lang
# Copyright (C) 2024-  Kodama Takuya <otegami@clear-code.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

require 'redmine'

module WikiExtensionsChildPagesCountMacro
  Redmine::WikiFormatting::Macros.register do
    desc "Displays the number of child pages. With no argument, it displays the number of child pages from current wiki page. Examples:\n\n" +
         "{{child_pages_count}} -- can be used from a wiki page only\n" +
         "{{child_pages_count(depth=2)}} -- display the number of 2 levels nesting pages only\n" +
         "{{child_pages_count(Foo)}} -- display the number of all children pages form Foo"
    macro :child_pages_count do |obj, args|
      args, options = extract_macro_options(args, :parent, :depth)
      options[:depth] = options[:depth].to_i if options[:depth].present?

      page = nil
      if args.size > 0
        page = Wiki.find_page(args.first.to_s, :project => @project)
      elsif obj.is_a?(WikiContent) || obj.is_a?(WikiContentVersion)
        page = obj.page
      else
        raise t(:error_child_pages_count_macro)
      end
      raise t(:error_page_not_found) if page.nil? || !User.current.allowed_to?(:view_wiki_pages, page.wiki.project)

      child_pages = page.descendants(options[:depth])
      child_pages.size.to_s
    end
  end
end
