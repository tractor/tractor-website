#!/usr/bin/env ruby

require "rubygems"
require "redcarpet"

if ARGV.length < 1
    abort("Usage: ./build.rb <markdown file>")
end

class HTMLWithTweaks < Redcarpet::Render::HTML
    def header (text, level)
        if level > 1
            id = text.gsub(/\s+/, "-")
            id.gsub!(/[^\w\-]/, "")
            id.downcase!
            id.sub(/^[^a-z]+/, "")
            "\n<h#{level} id=\"#{id}\">#{text}</h#{level}>\n"
        else
            "\n<h1>#{text}</h1>\n"
        end
    end
    
    def block_code (code, language)
        language = "bash" if language.nil? or language.empty?
        if (code.count("\n") > 1)
            "\n<pre><code class=\"language-#{language} line-numbers\">#{code}</code></pre>\n"
        else
            "\n<pre><code class=\"language-#{language}\">#{code}</code></pre>\n"
        end
    end
end

template = File.open("_template.html") { |file| file.read }
markdown = File.open(ARGV[0]) { |file| file.readlines }
latest = File.open("latest.txt") { |file| file.read }

title_array = markdown.select { |str| str =~ /^\#\s+\w+(\s+\w+)*\s*\#*$/ }
if title_array.empty?
    title = ARGV[0].sub(/\.\w+$/, "")
else
    title = title_array[0].sub(/^\#\s+/,"").sub(/\s*\#*$/,"")
end
template.sub!("<!--TITLE-->", title)

parser = Redcarpet::Markdown.new(HTMLWithTweaks, :tables => true, :fenced_code_blocks => true, :no_intra_emphasis => true)
content = parser.render(markdown.join.gsub("<!--LATEST-->",latest.strip))
content = Redcarpet::Render::SmartyPants.render(content)
template.sub!("<!--CONTENT-->", content)

$stdout.write(template)
