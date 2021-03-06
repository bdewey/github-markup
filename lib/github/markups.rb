markup(:markdown, /md|mkdn?|mdown|markdown/) do |content|
  Markdown.new(content).to_html
end

markup(:redcloth, /textile/) do |content|
  RedCloth.new(content).to_html
end

markup('github/markup/rdoc', /rdoc/) do |content|
  GitHub::Markup::RDoc.new(content).to_html
end

command(:rest2html, /rest|rst/)

command('asciidoc -s --backend=xhtml11 -o - -', /asciidoc/)

# pod2html is nice enough to generate a full-on HTML document for us,
# so we return the favor by ripping out the good parts.
#
# Any block passed to `command` will be handed the command's STDOUT for
# post processing.
command("/usr/bin/env pod2html", /pod/) do |rendered|
  require 'fileutils'
  if rendered =~ /<body.+?>\s*(.+)\s*<\/body>/mi
    FileUtils.rm("pod2htmd.tmp") if File.exists?('pod2htmd.tmp') rescue nil
    FileUtils.rm("pod2htmi.tmp") if File.exists?('pod2htmi.tmp') rescue nil
    $1.sub('<!-- INDEX BEGIN -->', '').sub('<!-- INDEX END -->', '')
  end
end
