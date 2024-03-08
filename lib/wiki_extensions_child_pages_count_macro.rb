# Wiki Extensions plugin for Redmine
# Copyright (C) 2009-2012  Haruyuki Iida
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
    desc "Displays the number of child pages.\n\n" +
           "{{child_page_count}}\n"
    macro :child_pages_count do |obj, args|
      # TODO
      # - Add test
      # - Think whether we display this count with words or not
      return unless obj.is_a?(WikiContent)

      child_pages = obj.page.descendants
      child_pages.count
    end
  end
end
