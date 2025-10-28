module BoxesHelper
  def markdown(text)
    return "" if text.blank?

    options = {
      filter_html: false,
      hard_wrap: true,
      link_attributes: { rel: "nofollow", target: "_blank" },
      space_after_headers: true
    }

    extensions = {
      autolink: true,
      fenced_code_blocks: true,
      lax_spacing: true,
      no_intra_emphasis: true,
      strikethrough: true,
      superscript: true,
      tables: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end
end
