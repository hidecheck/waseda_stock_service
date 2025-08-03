import json

import requests
from bs4 import BeautifulSoup

from soup_selector import PRICE_VALUE, SYMBOL_NAME

import functions_framework

PRICE_KEY = "price"
SYMBOL_KEY = "symbol_name"
SELECTORS = {PRICE_KEY: PRICE_VALUE, SYMBOL_KEY: SYMBOL_NAME}

def get_url(symbol_code):
    url = "https://finance.yahoo.co.jp/quote/"

    # 数字チェック
    first_three_chars = symbol_code[:3]
    if first_three_chars.isdigit():
        url = url + symbol_code + ".T"
    else:
        url = url + symbol_code

    return url


def get_selector_value(soup, selector):
    elems = soup.select(selector)

    print(f"elems: {elems}")  # 何が取得できたかログに出力する

    if elems:
        value = elems[0].contents[0]
        if selector == PRICE_VALUE:
            value = value.replace(',', '')
            print(f"価格: {value}")

        return value
    else:
        # 要素が見つからなかった場合の処理
        print("🚨 指定されたセレクタに一致する要素が見つかりませんでした。")
        return "-1"  # 例として"0"を返す


def fetch_stock_price(symbol_code):
    url = get_url(symbol_code)
    print(f"request to {url}")

    stock_info = {
        SYMBOL_KEY: "-1",
        PRICE_KEY: "-1"
    }

    try:
        # dummy_user_agent = 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0'
        # res = requests.get(url, headers={"User-Agent": dummy_user_agent})
        res = requests.get(url)
        res.raise_for_status()  # HTTPエラーがあれば例外を発生させる
        soup = BeautifulSoup(res.text, "lxml")  # lxmlパーサーを使う


        for key, selector in SELECTORS.items():
            value = get_selector_value(soup, selector)
            stock_info[key] = value

        return stock_info

    except requests.exceptions.RequestException as e:
        print(f"🚨 HTTPリクエストエラーが発生しました: {e}")
        return stock_info  # エラー時には特定の値を返す
    except IndexError as e:
        print(f"🚨 スクレイピングエラー（要素が見つからない）: {e}")
        return stock_info
    except Exception as e:
        print(f"🚨 予期せぬエラーが発生しました: {e}")
        return stock_info


@functions_framework.http
# def handler():
def handler(request):
    print("### START ###")
    print(request.args.get('symbol_code'))
    param_code = request.args.get("code")

    symbol_codes = param_code.split(",")
    stocks = []
    for symbol_code in symbol_codes:
        print(symbol_code)
        stock_info = fetch_stock_price(symbol_code=symbol_code)
        print(stock_info)
        stock_info["symbol_code"] = symbol_code
        stocks.append(stock_info)

    print("### END ###")
    headers = {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json"
    }
    res = {"stocks": stocks}
    print(res)

    return json.dumps(res), 200, headers


# from flask import Flask, request
#
# app = Flask(__name__)
#
# if __name__ == '__main__':
#     with app.test_request_context(query_string={'code': '9697,7203'}):
#         ret = handler()
#         print(ret)
