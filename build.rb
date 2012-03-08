#!/usr/bin/env ruby

require "redcarpet"

if ARGV.length < 1
    $stderr.puts("Usage: ./build <markdown file>")
    exit
end

template = File.new("_template.html").read
markdown = File.new(ARGV[0]).readlines

title_array = markdown.select { |str| str =~ /^\#\s+\w+\s*\#*$/ }
if title_array.empty?
    title = ARGV[0].sub(/\.\w+$/, "")
else
    title = title_array[0].sub(/^\#\s+/,"").sub(/\s*\#*$/,"")
end
template.sub!("<!--TITLE-->", title)

parser = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :tables => true, :fenced_code_blocks => true)
content = parser.render(markdown.join("\n"))
content = Redcarpet::Render::SmartyPants.render(content)
template.sub!("<!--CONTENT-->", content)

$stdout.write(template)
