require File.dirname(__FILE__) + '/../test_helper'

class WikiExtensionsChildPagesCountTest < Redmine::HelperTest
  include ApplicationHelper
  include ERB::Util

  fixtures :projects, :wikis, :wiki_pages, :wiki_contents, :issues

  def test_child_pages_count
    wiki_page = WikiPage.find(2)

    assert_equal 3, wiki_page.descendants.size
    assert_equal '<p>3</p>', textilizable('{{child_pages_count}}', object: wiki_page.content)
  end

  def test_child_pages_count_in_issue_page
    issue = Issue.first
    expected_error_macro_message = '<p>This {{child_pages_count}} macro can be called from wiki pages only</p>'

    assert_equal expected_error_macro_message, textilizable('{{child_pages_count}}', object: issue)
  end
end
