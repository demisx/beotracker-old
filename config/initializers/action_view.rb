ActionView::TemplateRenderer.class_eval do

  def render_template_with_tracking(template, layout_name = nil, locals = {})
    # with this gsub, we convert a file path /folder1/folder2/subfolder/filename.html.erb to subfolder-filename
    @view.instance_variable_set(:@_rendered_template, template.inspect.gsub(/(\..*)/, '').split('/')[-2..-1].join('-').gsub(/_/, '-') )
    out = render_template_without_tracking(template, layout_name, locals)
    @view.instance_variable_set(:@_rendered_template, nil)
    return out
  end

  alias_method_chain :render_template, :tracking
end
