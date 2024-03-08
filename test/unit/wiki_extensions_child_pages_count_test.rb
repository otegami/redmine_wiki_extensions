require File.dirname(__FILE__) + '/../test_helper'

class WikiExtensionsChildPagesCountTest < ActiveSupport::TestCase
  include ApplicationHelper
  include ERB::Util

  fixtures :projects, :wikis, :wiki_pages, :wiki_contents

  def test_child_pages_count
    wiki_page = WikiPage.find(2)

    assert_equal 3, wiki_page.descendants.size
    assert_equal '<p>3</p>', textilizable('{{child_pages_count}}', object: wiki_page.content)
  end
end
