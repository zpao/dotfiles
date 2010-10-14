# Redirect to output path and enforce it exists.
@html_path = '../doc/'
@html_name = @html_path + html_name
FileUtils.mkpath File.dirname( html_name )

@head_nodes << '<link rel="stylesheet" type="text/css" media="screen" href="' + root_path + 'style.css" />'
@head_nodes << '<link rel="stylesheet" type="text/css" media="print" href="' + root_path + 'printstyle.css" />'

@crumbs << 'Tutorials'

