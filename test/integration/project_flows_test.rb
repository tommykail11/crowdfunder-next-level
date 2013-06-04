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

    # Click a link to project1's show page
    click_link 'Project 1'
    # Assert we're on Project1's show page
    assert_equal project_path(project1), current_path
    # Assert the h1 has the title
    assert find('h1:first').has_content? project1.title
  end

  test "navigation" do
    # Create a project to visit its show page at the end of the test
    project1 = FactoryGirl.create(:project, :title => "Project 1")
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

    # On a project's show page, the Projects nav element should still be active
    click_link 'Project 1'
    assert_equal "Projects", find('.navbar ul li.active a').text
  end
end
