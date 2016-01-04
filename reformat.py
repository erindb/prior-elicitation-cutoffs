import re

f = open("prior.results", "r")
#w = open("prior-insurance-inventory-edited.results", "w")
w = open("prior-edited.results", "w")
to_write = ["subj\tlang\tage\tcomments\tcutoff\titem\tdir\tresponse"]
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
					cutoff = response
		elif colnames[i] == '"workerid"':
				subj = response
	for datum in data:
		metadata = [subj, lang, age, comments, cutoff]
		to_write.append("\t".join(metadata + datum))
w.write("\n".join(to_write))

f = open("prior.results", "r")
w = open("prior-insurance-inventory-edited.results", "w")
to_write = ["subj\tlang\tage\tcomments\tcutoff\titem\tdir\tresponse"]
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
					cutoff = response
		elif colnames[i] == '"workerid"':
				subj = response
	for datum in data:
		metadata = [subj, lang, age, comments, cutoff]
		to_write.append("\t".join(metadata + datum))
w.write("\n".join(to_write))
f.close()
w.close()

f = open("prior-elicitation.results", "r")
w = open("prior-edited.results", "a")
to_write = [""]
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
					cutoff = response
		elif colnames[i] == '"workerid"':
				subj = response
	for datum in data:
		metadata = [subj, lang, age, comments, cutoff]
		to_write.append("\t".join(metadata + datum))
w.write("\n".join(to_write))

f = open("prior.results", "r")
w = open("prior-insurance-inventory-edited.results", "w")
to_write = ["subj\tlang\tage\tcomments\tcutoff\titem\tdir\tresponse"]
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
					cutoff = response
		elif colnames[i] == '"workerid"':
				subj = response
	for datum in data:
		metadata = [subj, lang, age, comments, cutoff]
		to_write.append("\t".join(metadata + datum))
w.write("\n".join(to_write))
f.close()
w.close()
