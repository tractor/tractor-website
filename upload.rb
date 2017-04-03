#!/usr/bin/env ruby

require "tmpdir"

if ARGV.length < 1
    abort("Usage: ./upload.rb <files>")
end

status = true

Dir.mktmpdir do |tmpdir|
    ARGV.each do |filename|
        basename = File.basename(filename)
        if filename =~ /\.html$/
            html = File.open(filename) { |file| file.read }
            html.gsub!(/\"([\w\-]+)\.html([\"\#])/, '"\1\2')
            file = File.open(tmpdir + "/" + basename, "w") { |file| file.write(html) }
        elsif filename.count("/") > 0
            subdir = File.join(tmpdir, File.dirname(filename))
            Dir.mkdir(subdir) unless Dir.exist? subdir
            FileUtils.copy(filename, subdir)
        else
            FileUtils.copy(filename, tmpdir)
        end            
    end
    
    status = system("scp -r #{tmpdir}/* `cat upload_target`")
end

exit(status)
