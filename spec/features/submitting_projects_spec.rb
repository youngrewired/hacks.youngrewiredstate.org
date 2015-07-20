require 'rails_helper'

RSpec.describe "submitting projects", type: :feature do

  let(:event) { create(:event_with_centres) }
  let!(:centre) { create(:centre, event: event) }

  it 'can submit a project' do
    visit event_path(event)
    click_on 'Submit your project'

    select(centre.name, from: "project[centre_id]")
    fill_in 'project[team]', with: 'Walt Disney'
    fill_in 'project[twitter]', with: '@Disney'

    fill_in 'project[title]', with: 'Disneyland'
    fill_in 'project[description]', with: 'Here age relives fond memories of the past, and here youth may savor the challenge and promise of the future.'
    fill_in 'project[url]', with: 'https://disneyland.disney.go.com/'
    fill_in 'project[code_url]', with: 'https://github.com/disney'
    fill_in 'project[tag_list_with_hashes]', with: '#disney #disneyland'

    attach_file 'project[image]', path_to_stub_uploaded_image
    fill_in 'project[secret]', with: 'mickey mouse'

    click_on 'Submit my project'

    expect(page).to have_content('Thanks for submitting your project')

    expect(page).to have_content('Disneyland')
    expect(page).to have_content('by Walt Disney')
    expect(page).to have_content('Here age relives fond memories of the past, and here youth may savor the challenge and promise of the future.')

    expect(page).to have_css('img.screenshot')

    expect(page).to have_link('@Disney', 'https://twitter.com/Disney')
    expect(page).to have_link('disneyland.disney.go.com', href: 'https://disneyland.disney.go.com/')
    expect(page).to have_link('github.com/disney', href: 'https://github.com/disney')
  end

  it 'can edit a project' do
    project = create(:project, event: event, centre: centre)

    visit event_path(event)

    click_on centre.name
    click_on project.title
    click_on 'Edit this project'

    fill_in 'project[title]', with: 'Jurassic Park'
    fill_in 'project[team]', with: 'John Hammond'
    fill_in 'project[submitted_secret]', with: project.secret

    click_on 'Save changes to my project'

    expect(page).to have_content('Your changes have been saved')

    expect(page).to have_content('Jurassic Park')
    expect(page).to have_content('by John Hammond')
  end

end
