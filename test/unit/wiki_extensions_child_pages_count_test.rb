require File.dirname(__FILE__) + '/../test_helper'

class WikiExtensionsChildPagesCountTest < Redmine::HelperTest
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
    assert_equal '<p>1</p>', textilizable('{{child_pages_count(Child_1)}}')
  end

  def test_with_depth_option
    wiki_page = WikiPage.find(2)
    assert_equal '<p>2</p>', textilizable('{{child_pages_count(depth=1)}}', object: wiki_page.content)
  end

  def test_author_option_with_current_user
    wiki_page = WikiPage.find(2)
    wiki_child_page_content = wiki_page.descendants.first.content
    wiki_child_page_content.author = User.find(2)
    wiki_child_page_content.save!
    
    User.current = User.find(1)
    assert_equal '<p>2</p>', textilizable('{{child_pages_count(author=current)}}', object: wiki_page.content)
  end

  def test_author_option_with_another_user
    another_user = User.find(2)
    wiki_page = WikiPage.find(2)
    wiki_child_page_content = wiki_page.descendants.first.content
    wiki_child_page_content.author = another_user
    wiki_child_page_content.save!

    assert_equal '<p>1</p>', textilizable("{{child_pages_count(author=#{another_user.login})}}", object: wiki_page.content)
  end

  def test_author_option_with_non_existed_user
    wiki_page = WikiPage.find(2)
    macro_error_message = <<~MESSAGE.gsub("\n", "")
<p>
<div class="flash error">
Error executing the <strong>child_pages_count</strong> macro (User not found)
</div>
</p>
    MESSAGE
    assert_equal macro_error_message, textilizable("{{child_pages_count(author=non_existed_user)}}", object: wiki_page.content)
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

  def test_in_another_porject_wiki_without_permissions
    another_project_wiki = Project.find(2).wiki.pages.first
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
