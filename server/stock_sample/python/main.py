import json

import requests
from bs4 import BeautifulSoup

from soup_selector import PRICE_VALUE

import functions_framework


def get_url(stock_code):
    url = "https://finance.yahoo.co.jp/quote/"

    # 数字チェック
    first_three_chars = stock_code[:3]
    if first_three_chars.isdigit():
        url = url + stock_code + ".T"
    else:
        url = url + stock_code

    return url


def fetch_stock_price(stock_code):
    url = get_url(stock_code)
    print(f"request to {url}")
    # dummy_user_agent = 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0'
    # res = requests.get(url, headers={"User-Agent": dummy_user_agent})
    res = requests.get(url)
    print(res.status_code)

    print("---------------------")
    print(res.text)
    print("---------------------")
    soup = BeautifulSoup(res.text, "html.parser")
    elems = soup.select(PRICE_VALUE)
    print(elems)
    price_with_comma = elems[0].contents[0]
    return price_with_comma.replace(',', '')


@functions_framework.http
def handler():
# def handler(request):
    print("### START ###")
    # print(request.args.get('stock_code'))
    stock_code = request.args.get("stock_code")
    print(stock_code)
    price = fetch_stock_price(stock_code=stock_code)
    print(price)
    res = {
        "stock_code": stock_code,
        "price": price
    }
    print("### END ###")
    headers = {"Access-Control-Allow-Origin": "*"}
    # res = {"status": "OK"}

    return (json.dumps(res), 200, headers)


from flask import Flask, request

app = Flask(__name__)

if __name__ == '__main__':
    with app.test_request_context(query_string={'stock_code': '9697'}):
        ret = handler()
        print(ret)
