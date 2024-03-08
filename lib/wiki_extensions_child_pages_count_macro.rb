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
      child_pages.size
    end
  end
end
