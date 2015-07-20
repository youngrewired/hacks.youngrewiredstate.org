require 'rails_helper'

RSpec.describe "managing events", type: :feature do

  before do
    sign_in_admin
  end

  it 'can create an event' do
    visit admin_events_path
    click_on 'Add a new event'

    fill_in 'Title', with: 'Hack day'
    fill_in 'Start date', with: '2015-08-01'
    fill_in 'Slug', with: 'hack-day'
    fill_in 'Event homepage', with: 'http://yrs.io'
    select 'Hacks grouped by centre', from: 'Event type'
    uncheck 'Allow projects to be submitted and edited?'

    click_on 'Create Event'

    expect(page).to have_content(/has been created/)

    within 'table' do
      expect(page).to have_content('Hack day')
    end
  end

  it 'can add centres to an event', js: true do
    event = create(:event_with_centres)

    visit admin_events_path

    row = page.find('tr', text: event.title)
    within row do
      click_on 'Edit'
    end

    within page.find('fieldset', text: 'Centres') do
      click_on 'Add a centre'

      within 'ol div:nth-of-type(1)' do
        fill_in 'Name', with: 'London'
        fill_in 'Slug', with: 'london'
      end

      click_on 'Add a centre'

      within 'ol div:nth-of-type(2)' do
        fill_in 'Name', with: 'Birmingham'
        fill_in 'Slug', with: 'birmingham'
      end

      click_on 'Add a centre'

      within 'ol div:nth-of-type(3)' do
        fill_in 'Name', with: 'Glasgow'
        fill_in 'Slug', with: 'glasgow'
      end
    end

    click_on 'Update Event'

    event.reload

    expect(page).to have_content('has been saved')
    expect(event.centres.size).to eq(3)
  end

  it 'can add award categories to an event', js: true do
    event = create(:event)

    visit admin_events_path

    row = page.find('tr', text: event.title)
    within row do
      click_on 'Edit'
    end

    within page.find('fieldset', text: 'Award Categories') do
      click_on 'Add an award category'

      within 'ol div:nth-of-type(1)' do
        fill_in 'Title', with: 'Best in show'
        select 'Award', from: 'Format'
        select 'Gold', from: 'Level'
        check 'Show in winners list?'
      end

      click_on 'Add an award category'

      within 'ol div:nth-of-type(2)' do
        fill_in 'Title', with: 'Runner up'
        select 'Award', from: 'Format'
        select 'Silver', from: 'Level'
        uncheck 'Show in winners list?'
      end
    end

    click_on 'Update Event'

    event.reload

    expect(page).to have_content('has been saved')
    expect(event.award_categories.size).to eq(2)
  end

end
