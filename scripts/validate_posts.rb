#!/usr/bin/env ruby
# Validate Jekyll post metadata before GitHub Pages deployment.
require "yaml"
require "date"

errors = []
layout = File.read("_layouts/home.html", encoding: "UTF-8")
known_sections = layout.scan(/data-section="([^"]+)"/).flatten.uniq

Dir.glob("_posts/*.{md,markdown}").sort.each do |path|
  source = File.read(path, encoding: "UTF-8")
  lines = source.lines
  unless lines.first&.strip == "---"
    errors << "#{path}: Front Matter must start with --- on line 1"
    next
  end

  closing = (1...lines.length).find { |index| lines[index].strip == "---" }
  unless closing
    errors << "#{path}: closing Front Matter delimiter --- is missing"
    next
  end
  if lines[closing + 1] && !lines[closing + 1].strip.empty?
    errors << "#{path}: add a blank line after closing Front Matter delimiter"
  end

  raw_yaml = lines[1...closing].join
  begin
    metadata = YAML.safe_load(raw_yaml, permitted_classes: [Date, Time], aliases: false) || {}
  rescue Psych::Exception => e
    errors << "#{path}: invalid YAML Front Matter (#{e.message.lines.first.strip})"
    next
  end

  errors << "#{path}: title is missing" if metadata["title"].to_s.strip.empty?
  errors << "#{path}: date is missing" if metadata["date"].nil?
  categories = metadata["categories"]
  errors << "#{path}: categories must be a non-empty array" unless categories.is_a?(Array) && categories.any?
  section = metadata["section"].to_s.strip
  if !section.empty? && !known_sections.include?(section)
    errors << "#{path}: section '#{section}' is not defined in the blog sidebar"
  end
end

if errors.any?
  warn "Post validation failed:"
  errors.each { |error| warn " - #{error}" }
  exit 1
end

puts "Validated #{Dir.glob("_posts/*.{md,markdown}").length} posts. Front Matter and sidebar section references are valid."
