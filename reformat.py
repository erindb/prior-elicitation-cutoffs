import re

f = open("prior-elicitation.results", "r")
w = open("prior-editied.results", "w")
to_write = []
header = f.readline()
colnames = header[:-1].split("\t")
for line in f:
	cells = line[:-1].split("\t")
	data = []
	comments = ''
	age = ''
	lang = ''
	cutoff = ''
	subj = ''
	for i in range(len(cells)):
		response = cells[i][1:-1]
		m = re.match(r'"Answer.(.*)"', colnames[i])
		if m:
			if re.match(r'"Answer.*-.*"', colnames[i]):
				item, direction = m.groups()[0].split("-")
				data.append([item, direction, response])
			else:
				colname = m.groups()[0]
				if colname == "comments":
					comments = response[2:-2]
				elif colname == "age":
					age = response[2:-2]
				elif colname == "language":
					lang = response[2:-2]
				elif colname == "cutoff":
					cutoff = response[2:-2]
		elif colnames[i] == '"workerid"':
				subj = response
	for datum in data:
		metadata = [subj, lang, age, comments, cutoff]
		to_write.append("\t".join(metadata + datum))
w.write("\n".join(to_write))