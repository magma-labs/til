# frozen_string_literal: true

require 'red_carpet_code_highlighter'
require 'tilt/redcarpet'

module MarkdownHelper
  def markdown
    @markdown ||= Redcarpet::Markdown.new(
      RedCarpetCodeHighlighter,
      autolink: true,
      fenced_code_blocks: true,
      no_intra_emphasis: true,
      strikethrough: true,
      space_after_headers: true,
      underline: true,
      highlight: true,
      quote: true
    )
  end

  def markdown_render(md)
    sanitize find_and_preserve markdown.render md
  end
end
