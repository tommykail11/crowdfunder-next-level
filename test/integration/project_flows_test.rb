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
    # Only the projects nav element should be active
    page.assert_selector '.navbar ul li.active a', count: 1

    # On a project's show page, the Projects nav element should still be active
    click_link 'Project 1'
    assert_equal "Projects", find('.navbar ul li.active a').text
  end

  test "pagination" do
    user = FactoryGirl.create :user
    50.times { |i| FactoryGirl.create(:project, title: "Project #{i}", user: user) }

    visit "/projects"

    #Expect the most recently created projects on page 1 (8 per page)
    assert page.has_content?('Displaying projects 1 -8 of 50 in total')
    assert page.has_content?('Project 49')
    assert page.has_no_content?('Project 41')
    page.assert_selector 'li.project', count: 8

    # Expect pagination link and click page 2
    page.find('.pagination').click_link '2'
    assert projects_path(page: 2), current_path

    # Expect page 2 to have the next 8 projects
    assert page.has_content?('Project 41')
    assert page.has_no_content?('Project 32')
  end
end