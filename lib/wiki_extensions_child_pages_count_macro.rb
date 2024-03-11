require 'redmine'

module WikiExtensionsChildPagesCountMacro
  Redmine::WikiFormatting::Macros.register do
    desc "Displays the number of child pages.\n\n" +
         "{{child_page_count}}\n"
    macro :child_pages_count do |obj, args|
      raise t(:error_child_pages_count_macro) if [WikiContent, WikiContentVersion].none? { |wiki| obj.is_a?(wiki) }

      child_pages = obj.page.descendants
      child_pages.size.to_s
    end
  end
end
