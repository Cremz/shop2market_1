# shop2market_1

Write a program that crawls a given website (up to 3 levels deep, maximum 50
pages) and counts all input elements (<input...) per page. The counts per 
page are for the inputs on that page plus all the inputs of the pages it refers to. 

Performance is a key factor so do a few optimizations for performance, like 
concurrent processing of the web pages.

Don't use a gem like Anemone for this, write your own crawling functions.

Provide: 
- Tests

- A command line runnable class that crawls a website

Acceptance criteria:

Input: url_of_website

Output example: 

home.html - 20 inputs

contact.html - 5 inputs

products.html - 10 inputs

faq.html - 5 inputs


How to run
----------

Simply use ruby app.rb in your terminal to start the crawler. 
You will be asked for a url, write a full url with http and if it's a folder style url use a trailing slash.

Solution
--------

I've implemented a crawler class that gets initialized with the url it needs to crawl. 
I have two public methods, one for the final output and one that does the actual crawl.

I have an array of hashes that is used to store the found links and the number of inputs. 
A while loop is performed until the 50 link limit is reached or until the website has been crawled for three levels.

On each iteration it crawls all the new pages. In the first iteration it only cralws the inputed url, 
and returns a list of links that are found on that initial page. 
On the second itteration it only checks the newly added links, without the initial one and so on.

To speed things up I've added a threads array, each new link gets a new thread and and then the main thread
continues once all the other ones are finished.

The final output shows the list of links found, their number and the number inputs on each of them. 
I also show the time it takes for the crawler to run. I've tested on some websites, depending on the response time,
i've gotten between 0.7 seconds (bbc.co.uk) to 4 seconds. After adding the threads, on a test site, 
the processing time went from 8 seconds to 3.5 seconds.

TODO
----

Because the processing of urls as is takes some time, i've decided to use a simple hack to check if a link
is not an image. However, a better method could be implemented to check the headers of each link and match it 
to a html type. I did not want to check the headers for each link, because at the time this check is performed, 
the links are just added to the results page and only in the following itteration they are crawled for other links
and the inputs counter. So I would have had to read each link twice which would really slow down the app.

Testing
-------

I've added rspec tests for the methods of my class and also added simplecov for coverage (currently 100%).

