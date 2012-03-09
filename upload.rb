#!/usr/bin/env ruby

require "tmpdir"

if ARGV.length < 1
    $stderr.puts("Usage: ./upload.rb <files>")
    exit
end

Dir.mktmpdir do |tmpdir|
    ARGV.each do |filename|
        basename = File.basename(filename)
        if filename =~ /\.html$/
            html = File.open(filename) { |file| file.read }
            html.gsub!(/\"([\w\-]+)\.html([\"\#])/, '"\1\2')
            file = File.open(tmpdir + "/" + basename, "w") { |file| file.write(html) }
        else
            FileUtils.copy(filename, tmpdir)
        end            
    end
    
    system("scp #{tmpdir}/* `cat upload_target`")
end
