import markdown


file = 'prt.md'

with open(file, "r", encoding="utf-8") as input_file:
	text = input_file.read()

html = markdown.markdown(text,
	extensions=[
		'meta',
		'toc',
		'tables',
		'fenced_code'
	],
	extension_configs={
		'toc':{
			'title': '目次',
			'toc_depth': '2-4',
		}
	})

out = file.replace('.md', '.html')
with open(out, "w", encoding="utf-8", errors="xmlcharrefreplace") as output_file:
	output_file.write(html)