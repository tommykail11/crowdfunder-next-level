require 'test_helper'

class ProjectFlowsTest < ActionDispatch::IntegrationTest
  
  test "browsing projects" do
    project1 = FactoryGirl.create(:project, :title => "Project 1")
    project2 = FactoryGirl.create(:project, :title => "Project 2")
    project3 = FactoryGirl.create(:project, :title => "Project 3")

    visit "/projects"

    assert_equal projects_path, current_path

    assert page.has_content?('Listing projects')

    assert page.has_content?('Project 1')
    assert page.has_content?('Project 2')
    assert page.has_content?('Project 3')
  end

  test "navigation" do
    # visit the root URL
    visit "/"
    # Assert the page we're on is root
    assert_equal root_path, current_path
    # Assert the home nav element is active
    assert_equal "Home", find('.navbar ul li.active a').text

    # Click on the link to Projects
    find('.navbar ul').click_link('Projects')
    # Assert the page we're on is the projects page
    assert_equal projects_path, current_path
    # Assert the projects nav element is active
    assert_equal "Projects", find('.navbar ul li.active a').text
  end
end
