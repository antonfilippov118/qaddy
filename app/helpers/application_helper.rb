module ApplicationHelper

  def full_title(page_title)
    base_title = "laComparto.com"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def deep_copy(o)
    Marshal.load(Marshal.dump(o))
  end

end
