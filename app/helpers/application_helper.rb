# frozen_string_literal: true

module ApplicationHelper
  def simple_time_select_options
    minutes = %w(00 15 30 45)
    hours = (0..23).to_a.map { |h| format('%.2d', h) }
    options = hours.map do |h|
      minutes.map { |m| "#{h}:#{m}" }
    end.flatten
    options_for_select(options)
  end

  def nav_bar(classes = 'nav navbar-nav')
    content_tag(:ul, class: classes) do
      yield
    end
  end

  def nav_link(text, path, options = { class: '' })
    options[:class].prepend(current_page?(path) ? 'active ' : '')
    content_tag(:li, options) do
      link_to text, path
    end
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, { sort: column, direction: direction },  { class: css_class }
  end

  def class_assignment(column)
    column == sort_column ? "current #{sort_direction}" : nil
  end

  def date_range(start_date, end_date)
    date_format = '%b %-d, %Y'
    "#{start_date.strftime(date_format)}–#{end_date.strftime(date_format)}"
  end

  def true?(obj)
    obj.to_s == 'true'
  end
end
