module ApplicationHelper

  def mkdn(string)
    RDiscount.new(
      html_escape(string)
    ).to_html.html_safe
  end

  def home_url
    ENV["HOME_URL"]
  end

end
