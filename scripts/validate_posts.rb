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
  errors << "#{path}: section is required for sidebar classification" if section.empty?
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
