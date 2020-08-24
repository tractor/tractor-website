#!/usr/bin/env ruby

require "tmpdir"
require "rubygems"
require "nokogiri"

if ARGV.length < 1
    abort("Usage: ./upload.rb [-d] <files>")
end

status = true
to_docs = false

if ARGV[0] == "-d"
    to_docs = true
    args = ARGV.drop(1)
else
    args = ARGV
end

Dir.mktmpdir do |tmpdir|
    args.each do |filename|
        basename = File.basename(filename)
        # Preserve subdirectory structure (NB: this is exclusive with modifying HTML files, but none are currently stored in subdirectories)
        if filename.count("/") > 0
            subdir = File.join(tmpdir, File.dirname(filename))
            Dir.mkdir(subdir) unless Dir.exist? subdir
            FileUtils.copy(filename, subdir)
        # Strip .html suffixes from links (web only)
        elsif filename =~ /\.html$/ and not to_docs
            html = File.open(filename) { |file| file.read }
            html.gsub!(/\"([\w\-]+)\.html([\"\#])/, '"\1\2')
            File.open(tmpdir + "/" + basename, "w") { |file| file.write(html) }
        # Strip Google Analytics code (docs only)
        elsif filename =~ /\.html$/ and to_docs
            html = File.open(filename) { |file| file.read }
            doc = Nokogiri(html)
            doc.css("#analytics").remove
            File.open(tmpdir + "/" + basename, "w") { |file| file.write(doc) }
        else
            FileUtils.copy(filename, tmpdir)
        end            
    end
    
    if to_docs
        status = system("cp -Rv #{tmpdir}/* `cat docs_target`")
    else
        status = system("scp -r #{tmpdir}/* `cat upload_target`")
    end
end

exit(status)
