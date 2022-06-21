import markdown

source_file = 'prt.md'
template_file = 'template.html'

with open(source_file, "r", encoding="utf-8") as input_file:
	text = input_file.read()
	html = markdown.markdown(text,
		extensions=[
			'meta',
			'toc',
			'tables',
			'fenced_code',
			'codehilite',
			'pymdownx.b64'
		],
		extension_configs={
			'toc':{
				'title': '目次',
				'toc_depth': '2-4',
				'permalink': True,
			},
			'codehilite':{
				'pygments_style': 'colorful',
				'noclasses': True,
			}
		})


with open(template_file, 'r', encoding='utf-8') as template:
	html = template.read().replace('{{content}}', html)


out = source_file.replace('.md', '.html')
with open(out, "w", encoding="utf-8", errors="xmlcharrefreplace") as output_file:
	output_file.write(html)
