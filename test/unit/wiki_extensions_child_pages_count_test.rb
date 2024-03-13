require File.dirname(__FILE__) + '/../test_helper'

class WikiExtensionsChildPagesCountTest < Redmine::HelperTest
  include ApplicationHelper
  include ERB::Util

  fixtures :projects, :wikis, :wiki_pages, :wiki_contents, :wiki_content_versions, :issues,
           :roles, :enabled_modules, :users

  def setup
    super
    @project = Project.find(1)
  end

  def test_in_wiki_content
    wiki_page = WikiPage.find(2)
    assert_equal '<p>3</p>', textilizable('{{child_pages_count}}', object: wiki_page.content)
  end

  def test_in_wiki_content_version
    wiki_page = WikiPage.find(2)
    assert_equal '<p>3</p>', textilizable('{{child_pages_count}}', object: wiki_page.content.versions.first)
  end

  def test_with_child_page
    wiki_page = WikiPage.find(2)
    assert_equal '<p>1</p>', textilizable('{{child_pages_count(Child_1)}}', object: wiki_page.content)
  end

  def test_with_depth_option
    wiki_page = WikiPage.find(2)
    assert_equal '<p>2</p>', textilizable('{{child_pages_count(depth=1)}}', object: wiki_page.content)
  end

  def test_in_issue_page
    macro_error_message = <<-MESSAGE.gsub("\n", "")
<p>
<div class="flash error">
Error executing the <strong>child_pages_count</strong> macro
 (This {{child_pages_count}} macro can be called from Wiki pages only)
</div>
</p>
    MESSAGE
    assert_equal macro_error_message, textilizable('{{child_pages_count}}', object: Issue.first)
  end

  def test_without_permissions
    another_project_wiki = WikiPage.find(3)
    macro_error_message = <<~MESSAGE.gsub("\n", "")
<p>
<div class="flash error">
Error executing the <strong>child_pages_count</strong> macro (Page not found)
</div>
</p>
    MESSAGE
    assert_equal macro_error_message, textilizable('{{child_pages_count}}', object: another_project_wiki.content)
  end
end
