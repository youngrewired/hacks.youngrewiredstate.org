module ProjectsHelper
  GITHUB_URL_MATCH = %r{//(www\.)?github.com/(([A-Za-z0-9_-]+)(/[A-Za-z0-9_-]+)?)}i

  def twitter_links_for(project)
    output = []
    project.twitter.split(/, ?/).take(8).each do |t|
      clean_user = sanitize t.strip.sub('@','')
      output << link_to("@#{clean_user}", "http://twitter.com/#{clean_user}")
    end
    output.join(', ').html_safe
  end

  def no_picture_message
    ['A picture is worth a thousand words.','Every picture tells a story.'].sample
  end

  def format_github_url(url)
    url.match(GITHUB_URL_MATCH) do |m|
      return m[2]
    end
    return url
  end

  def suggested_tags
    (event.visible_projects.top_tags(12) - project.tags)[0..8]
  end

  def top_tags_for(projects)
    projects.top_tags(40).sort
  end
end
