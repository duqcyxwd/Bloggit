module ApplicationHelper
	def control_group_tag(errors, &block)
		if errors.any?
			content_tag :div, capture(&block), class: 'control-group error'
		else
			content_tag :div, capture(&block), class: 'control-group'
		end
	end

	class MarkdownRenderer < Redcarpet::Render::HTML
		def block_code(code, language)
			# CodeRay.highlight(code, language, :line_numbers => :table)
			# CodeRay.highlight(code, language)
			# CodeRay.scan(code, language).div
			# CodeRay.scan(code, language).div(:line_numbers => :table)
			CodeRay.scan(code, language||'ruby').html(:line_numbers => :table)
		end
	end

	def markdown(text)
		rndr = MarkdownRenderer.new(:filter_html => false, :hard_wrap => false)
		options = {
			:fenced_code_blocks => true,
			:no_intra_emphasis => true,
			:autolink => true,
			:strikethrough => true,
			:lax_html_blocks => true,
			:superscript => true
		}
		markdown_to_html = Redcarpet::Markdown.new(rndr, options)
		markdown_to_html.render(text).html_safe
	end

	# def markdown(text)
	# 	renderer = Redcarpet::Render::HTML.new
	# 	extensions = {fenced_code_blocks: true}
	# 	redcarpet = Redcarpet::Markdown.new(renderer, extensions)
	# 	(redcarpet.render text).html_safe
	# end
end

