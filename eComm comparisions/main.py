import re

import pandas as pd
import requests
from bs4 import BeautifulSoup

prod_dict = {}
prod_name = []
prod_desc = []
prod_rating = []
prod_review_count = []
prod_price = []
prod_url = []
page_urls = []
pid = ''


def scrape_main():
    search_word = input("enter you search keyword:\n ")
    # search_word = 'men formal shirt'
    param_page = '&page='
    header = {
        "Accept-Language": "en-US,en;q=0.9",
        "User-Agent": "Safari/605.1.15"
    }

    scrape_amazon(search_word, param_page, header)
    scrape_flipkart(search_word, param_page, header)
    print("Scraping Completed...")


def initialize_vars():
    prod_dict.clear()
    prod_name.clear()
    prod_desc.clear()
    prod_rating.clear()
    prod_review_count.clear()
    prod_price.clear()
    prod_url.clear()


def scrape_to_csv(fname, prod_dict):
    df = pd.DataFrame(prod_dict)
    df.to_csv(f'./{fname}')
    # print(df.head())


def scrape_amazon(search_word, param_page, header):
    initialize_vars()

    home_url = "https://www.amazon.in"
    base_url = "https://www.amazon.in/s?k="
    param_search_word = search_word.replace(" ", "+")

    pageNo = 1
    while not len(prod_url) > 300:
        endpoint = base_url + param_search_word + param_page + str(pageNo)
        print(endpoint)
        response = requests.get(url=endpoint, headers=header).text
        page_content = BeautifulSoup(response, "html.parser")

        # list of all products of current page
        div_c_selector_main = "s-main-slot s-result-list s-search-results sg-row"
        div_list = page_content.find('div', class_=div_c_selector_main)
        div_c_selector_prods = "sg-col-4-of-24 sg-col-4-of-12 s-result-item s-asin sg-col-4-of-16 sg-col s-widget-spacing-small sg-col-4-of-20"
        prod_list = div_list.findAll('div', class_=div_c_selector_prods)

        if len(prod_list) < 1:
            div_c_selector_prods = "sg-col-20-of-24 s-result-item s-asin sg-col-0-of-12 sg-col-16-of-20 sg-col s-widget-spacing-small sg-col-12-of-16"
            prod_list = div_list.findAll('div', class_=div_c_selector_prods)

        # iterate through all products
        for prod in prod_list:
            h2_c_selector_pattern = "a-size-mini a-spacing-none a-color-base "
            div_inner = prod.find('h2', {"class": re.compile(h2_c_selector_pattern)})

            # getting the product page url
            a_tag = div_inner.a
            try:
                t_url = a_tag['href']
                p_url = home_url + t_url
                # print(f"Prod URL: {p_url}")
                prod_url.append(p_url)
            except Exception as e:
                prod_url.append('')

            # get the product name
            span_list = a_tag.findAll('span')
            p_name = (span_list[0].text.split(' '))[0].strip()
            # print(f"Name: {p_name}")
            prod_name.append(p_name)

            # get the product description
            p_desc = a_tag.span.text.strip()
            # print(f"Description: {p_desc}")
            prod_desc.append(p_desc)

            # get the product rating
            div_c_selector_rating = "a-row a-size-small"
            div_rating = prod.find('div', class_=div_c_selector_rating)
            try:
                p_rating = div_rating.span.span.text
                # print(f"Rating: {p_rating}")
                prod_rating.append(p_rating)
            except Exception as e:
                prod_rating.append('')

            # get the product reviewed count
            try:
                a_c_selector_reviewed_count = "a-link-normal s-underline-text s-underline-link-text s-link-style"
                tcount = div_rating.find('a', class_=a_c_selector_reviewed_count)
                p_review_count = tcount.span.text
                # print(f"Reviewed: {p_reviewed_count}")
                prod_review_count.append(p_review_count)
            except Exception as e:
                prod_review_count.append('')

            # get product price with symbol
            try:
                span_c_selector_currency = "a-price-symbol"
                p_currency = prod.find('span', class_=span_c_selector_currency).text
                span_c_selector_price = "a-price-whole"
                t_price = prod.find('span', class_=span_c_selector_price).text
                p_price = p_currency + t_price
                # print(f"Price: {p_price}")
                prod_price.append(p_price)
            except Exception as e:
                prod_price.append('')

        pageNo += 1

    if str(page_content) != "":
        fname = 'amazon_' + search_word + '.csv'
        prod_dict = {
            "Name": prod_name,
            "Description": prod_desc,
            "Price": prod_price,
            "Rating": prod_rating,
            "Rating_Count": prod_review_count,
            "URL": prod_url
        }
        scrape_to_csv(fname, prod_dict)
    else:
        print("Unable to fetch data...")


def scrape_flipkart(search_word, param_page, header):
    initialize_vars()

    home_url = "https://www.flipkart.com"
    base_url = "https://www.flipkart.com/search?q="
    param_search_word = search_word.replace(" ", "%20")

    pageNo = 1
    while not len(prod_url) > 300:
        endpoint = base_url + param_search_word + param_page + str(pageNo)
        print(endpoint)
        response = requests.get(url=endpoint, headers=header).text
        main_page_content = BeautifulSoup(response, "html.parser")

        prod_div = main_page_content.find('div', class_='_1YokD2 _3Mn1Gg')
        prod_list = prod_div.findAll('div', class_='_1AtVbE col-12-12')
        for pg_urls in prod_list[:-2]:
            row_urls = pg_urls.findAll('a')
            for u1 in row_urls:
                t1 = u1['href']
                t2 = t1.split('pid=')
                t3 = t2[1].split('&')
                pid = t3[0]
                if all(pid not in item for item in page_urls):
                    p_url = home_url + str(t1)
                    page_urls.append(p_url)

        for p_url in page_urls:
            # read prod page
            item_page_response = requests.get(url=p_url, headers=header).text
            item_page_content = BeautifulSoup(item_page_response, "html.parser")

            # add url to list
            prod_url.append(p_url)

            # get prod name and desc
            prod_div = item_page_content.find('div', class_='aMaAEs')
            h1 = prod_div.find('h1', class_='yhB1nd')
            span = h1.findAll('span')
            try:
                p_name = span[0].text
                p_desc = span[1].text
            except Exception as e:
                p_desc = h1.span.text
                p_name = p_desc.split(' ')[0]

            prod_name.append(p_name)
            prod_desc.append(p_desc)

            # get prod price
            price_div = prod_div.find('div', class_='_30jeq3 _16Jk6d')
            try:
                p_price = price_div.text
                prod_price.append(p_price)
            except Exception as e:
                prod_price.append(' ')

            # get prod rating
            rating_div = prod_div.find('div', class_='_3LWZlK')
            try:
                p_rating = rating_div.text
                prod_rating.append(p_rating)
            except Exception as e:
                prod_rating.append(' ')

            # get prod rating count
            rating_count_div = prod_div.find('span', class_='_2_R_DZ')
            try:
                spans = rating_count_div.findAll('span')
                p_review_count = spans[0].text
                prod_review_count.append(p_review_count)
            except Exception as e:
                prod_review_count.append(' ')

        pageNo += 1

    if len(prod_url) > 1:
        fname = 'flipkart_' + search_word + '.csv'
        prod_dict = {
            "Name": prod_name,
            "Description": prod_desc,
            "Price": prod_price,
            "Rating": prod_rating,
            "Rating_Count": prod_review_count,
            "URL": prod_url
        }
        scrape_to_csv(fname, prod_dict)
    else:
        print("Unable to fetch data...")


scrape_main()
