# coding=utf-8

import time, random
import urllib2
from bs4 import BeautifulSoup
import re
import random

price_regex = r"g-b (amt )?bidsold(.*\r?\n?)(.*\r?\n)?(.*\r?\n)?.*\$([0-9,.]+)<"
 
def my_fetch(url_to_access):
	wt = random.uniform(15, 60)
	#Try not to annnoy ebay, with a random short wait
	time.sleep(wt)
	headers = { 'User-Agent': 'Mozilla/5.0 (X11; U; Linux i686) Gecko/20071127 Firefox/2.0.0.11' }
	req = urllib2.Request(url=url_to_access, headers=headers)
	f = urllib2.urlopen(req)
	html = f.read()
	return html

for item in ["watch"]:#["sweater", "wrist+watch", "laptop", "coffee+maker", "headphones", "sweater", "bike", "backpack", "purse", "electric+kettle"]: #"wrist+watch", "laptop", "coffee+maker", "headphones", 
	if item == "laptop":
		url = "http://www.ebay.com/sch/Laptops-Netbooks-/175672/i.html?_sop=13&LH_Sold=1&_from=R40&LH_Complete=1&_nkw=laptop&_ipg=200"
	elif item == "watch":
		#url = "http://www.ebay.com/sch/i.html?_sacat=0&_from=R40&LH_Complete=1&LH_Sold=1&_nkw=wrist+watch&LH_BIN=1&_ipg=200"
		url = "http://www.ebay.com/sch/Watches-/14324/i.html?_from=R40&LH_Complete=1&LH_Sold=1&_nkw=watch&_sop=13&_ipg=200"
	elif item == "headphones":
		url = "http://www.ebay.com/sch/Headphones-/112529/i.html?LH_BIN=1&LH_Complete=1&LH_Sold=1&rt=nc&_ipg=200"
		#url = "http://www.ebay.com/sch/i.html?LH_BIN=1&LH_Sold=1&_from=R40&LH_Complete=1&_sacat=0&_nkw=headphones&_dcat=112529&Fit%2520Design=Neckband&rt=nc"
	else :
		url = "http://www.ebay.com/sch/i.html?_sacat=0&_from=R40&_nkw="+item+"&LH_Complete=1&LH_Sold=1&_ipg=200&rt=nc"
	#soup = BeautifulSoup(my_fetch(url))
	string = my_fetch(url)
	print string
	prices = []
	for find in re.findall(price_regex, string):#"<div class=\"g-b bidsold\" itemprop=\"price\"> *\n? *\$([0-9,]*)</div>", string):
		prices.append(re.sub(r",", "", find[-1]))
	#nresults = int(re.sub(r",", "", re.findall(r"rcnt\">(.*)</span>", string)[-1]))
	per_page = 200
	#npages = nresults / per_page
	print item + ":",
	print prices
	for n in range(2,57):#range(2,npages):
		if item == "laptop":
			page_url = "http://www.ebay.com/sch/Laptops-Netbooks-/175672/i.html?_sop=13&LH_Sold=1&_pgn=" + str(n)+ "&_from=R40&LH_Complete=1&_nkw=laptop"
		elif item == "watch":
			#page_url = "http://www.ebay.com/sch/i.html?_sacat=0&_from=R40&LH_Complete=1&LH_Sold=1&_nkw=wrist+watch&LH_BIN=1&_pgn=" + str(n)
			page_url = "http://www.ebay.com/sch/Watches-/14324/i.html?_from=R40&LH_Complete=1&LH_Sold=1&_nkw=watch&_sop=13&_ipg=200&_pgn=" + str(n)
		elif item == "headphones":
			page_url = "http://www.ebay.com/sch/Headphones-/112529/i.html?LH_BIN=1&LH_Complete=1&LH_Sold=1&rt=nc&_ipg=200&_pgn=" + str(n)
		else:
			tags = ["&_from=R40", "&LH_Complete=1", "&LH_Sold=1", "&_nkw=" + item, "&_pgn=" + str(n), "&_ipg=200", "&_skc=200"]
			random.shuffle(tags)
			page_url = "http://www.ebay.com/sch/i.html?_sacat=0" + "".join(tags) + "&rt=nc"
		page_string = my_fetch(page_url)
		for find in re.findall(price_regex, page_string):#"<div class=\"g-b bidsold\" itemprop=\"price\"> *\n? *\$([0-9,]*)</div>", string):
			prices.append(re.sub(r",", "", find[-1]))
		print "n:",
		print n
		print item + ":",
		print prices
	f = open(re.sub("\+", "-", item)+".txt", "w")
	f.write("\n".join(prices))
	f.close()
	# print nresults
	# for i in range(100):
	# http://www.ebay.com/sch/i.html?_sacat=0&_from=R40&LH_Complete=1&LH_Sold=1&_nkw=watch&_pgn=2&_ipg=200&_skc=200&rt=nc
#re.findall(r"sboffer")

#g-b bidsold

#soup.find_all("div", "g-b bidsold", recursive=True)

# for div in soup.body.find(id="Body").find(id="LeftCenterBottomPanelDF").find_all("div"):
# 	print div.get("id")

# "body"
# "div" "VR CHROME  CHROME_28 CHROME_28_0" id="Body"
# "div" id="LeftCenterBottomPanelDF"
# "div" id="Center"
# "div" "c-std" id="CenterPanel"
# "div" id="Results"
# "div" "tabs-b"
# "div" "rs rsw t96"
# "table", "li rsittlref"
# "tbody", "lyr"
# "tr"
# "td", "prc"
# "div", "g-b bpo"
# "div", "g-b bidsold"
# "span", "sboffer"