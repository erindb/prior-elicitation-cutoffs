# coding=utf-8

import time, random
import urllib2
from BeautifulSoup import BeautifulSoup
import re
 
def my_fetch(url_to_access):
	wt = random.uniform(20, 60)
	#Try not to annnoy Google, with a random short wait
	time.sleep(wt)
	headers = { 'User-Agent': 'Mozilla/5.0 (X11; U; Linux i686) Gecko/20071127 Firefox/2.0.0.11' }
	req = urllib2.Request(url=url_to_access, headers=headers)
	f = urllib2.urlopen(req)
	return f.read()

for item in ["coffee+maker", "electric+kettle", "sweater", "headphones", "laptop", "bike", "backpack", "purse"]:
	print item
	power=1
	amount = 1
	start = 0
	while amount > 0:
		stepsize = 10**power
		#go by 10s to 100
		#go by 100s to 1,000
		#etc.
		#will stop before 10,000,000 for watches, so for watches, we'll scrape about 60 times (max 1hr if I wait between 20 and 60 sec)
		for i in range(10): #10 steps for each range
			min_price=start + i*stepsize
			#disclaimer="#this_is_for_linguistics_research"
			max_price=start + (i+1)*stepsize
			#url = "https://www.google.com/search?hl=en&tbm=shop&q=watch&oq=watch&gs_l=products-cc.3..0l10.135323.136137.0.136441.5.4.0.1.1.0.70.235.4.4.0...0.0...1ac.1.m0kjQXlKjj8#hl=en&q=watch&safe=off&tbm=shop&tbs=cat:201,price:1,ppr_min:"+min_price+",ppr_max:"+max_price+",vw:g"+disclaimer
			#url = "https://www.google.com/search?hl=en&tbm=shop&q="+item+"&oq="+item+"#hl=en&psj=1&q="+item+"&tbm=shop&tbs=vw:g,price:1,ppr_min:"+str(min_price)
			url = "https://www.google.com/search?hl=en&tbm=shop&q="+item+"&oq="+item+"#hl=en&psj=1&q="+item+"&tbm=shop&tbs=vw:g,price:1,ppr_min:"+str(min_price)+",ppr_max:"+str(max_price)
			html_str = my_fetch(url)

			#parse to find content of <div id="resultStats">
			parsed_html = BeautifulSoup(html_str)
			amount_text = parsed_html.body.find('div', attrs={'id':'resultStats'}).text
			amount = int(re.sub(",", "", amount_text.split(" ")[1]))

			print url
			print min_price, max_price, amount
		power+=1
		start = stepsize*10

#<div id="resultStats">About 20,500,000 results<nobr>  (0.59 seconds)&nbsp;</nobr></div>
#https://www.google.com/search?hl=en&tbm=shop&q=watch&oq=watch&gs_l=products-cc.3..0l10.135323.136137.0.136441.5.4.0.1.1.0.70.235.4.4.0...0.0...1ac.1.m0kjQXlKjj8#hl=en&q=watch&safe=off&tbm=shop&tbs=cat:201,price:1,ppr_min:0,ppr_max:1,vw:g
#https://www.google.com/search?hl=en&tbm=shop&q=watch&oq=watch&gs_l=products-cc.3..0l10.4021.4669.0.4856.5.4.0.1.1.0.68.232.4.4.0...0.0...1ac.1.W74R3hwKVow#hl=en&psj=1&q=watch&safe=off&tbm=shop&tbs=vw:g,cat:201,price:1,ppr_min:8000
#https://www.google.com/search?hl=en&tbm=shop&q=mug&oq=mug#hl=en&psj=1&q=mug&tbm=shop&tbs=vw:g,price:1,ppr_min:10
