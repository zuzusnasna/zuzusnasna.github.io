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
  body_lines = lines[(closing + 1)..] || []
  in_code_block = false
  previous_heading_level = 0
  has_h2 = false
  body_lines.each do |line|
    if line.match?(/^\s*(\x60{3,}|~{3,})/)
      in_code_block = !in_code_block
      next
    end
    next if in_code_block

    heading = line.match(/^(#+)\s+(.+)$/)
    next unless heading

    level = heading[1].length
    errors << "#{path}: body must not repeat the page title as an H1" if level == 1
    has_h2 = true if level == 2
    if level == 3 && previous_heading_level < 2
      errors << "#{path}: H3 heading has no preceding H2 section"
    elsif previous_heading_level.positive? && level > previous_heading_level + 1
      errors << "#{path}: heading level skips from H#{previous_heading_level} to H#{level}"
    end
    previous_heading_level = level
  end
  errors << "#{path}: code fence is not closed" if in_code_block
  errors << "#{path}: at least one H2 section is required" unless has_h2
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
  tags = metadata["tags"]
  errors << "#{path}: tags must be a non-empty array" unless tags.is_a?(Array) && tags.any?
  section = metadata["section"].to_s.strip
  if !section.empty? && !known_sections.include?(section)
    errors << "#{path}: section '#{section}' is not defined in the blog sidebar"
  end

  # Keep Jekyll category and sidebar section in the same top-level group.
  section_parent = case section
                   when /\Ajava-/ then "Java"
                   when /\Aspring-/ then "Spring"
                   when /\Adatabase-/ then "Database"
                   when /\Abackend-/ then "Backend"
                   when /\Afrontend-/ then "Frontend"
                   when /\Ainfra-/ then "Infra"
                   when "ml" then "ML"
                   else nil
                   end
  category = categories.is_a?(Array) ? categories.first.to_s : ""
  if section_parent && category.casecmp(section_parent) != 0
    errors << "#{path}: categories[0] '#{category}' does not match section '#{section}' (expected '#{section_parent}')"
  end

  unless File.basename(path).match?(/\A\d{4}-\d{2}-\d{2}-.+\.(md|markdown)\z/)
    errors << "#{path}: filename must start with YYYY-MM-DD- for Jekyll posts"
  end
end

if errors.any?
  warn "Post validation failed:"
  errors.each { |error| warn " - #{error}" }
  exit 1
end

puts "Validated #{Dir.glob("_posts/*.{md,markdown}").length} posts. Front Matter and sidebar section references are valid."
