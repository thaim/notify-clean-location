#!/usr/bin/env python
# encoding: utf-8

import datetime
import json
import logging
import os
import requests



locations = ['トイレ/風呂/洗面所',
             '玄関/台所',
             'ベッド/リビング',
             'PC周辺/クローゼット',
             '好きなところ']


def select_location(date):
    return locations[date.day//7]

def build_message(day):
    color = '#808080'
    location = select_location(day)
    text  = '今週は%sを掃除しましょう!' % location

    attachments = {"text": text, "color": color}

    return attachments

def lambda_handler(event, context):
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)
    content = build_message(datetime.datetime.today())

    # SlackにPOSTする内容をセット
    slack_message = {
        'channel': os.environ['slackChannel'],
        "attachments": [content],
    }

    # SlackにPOST
    try:
        req = requests.post(os.environ['slackPostURL'],
                            data=json.dumps(slack_message))
        logger.info("Message posted to %s", slack_message['channel'])
    except requests.exceptions.RequestException as e:
        logger.error("Request failed: %s", e)

if __name__ == '__main__':
    date = datetime.datetime.today()
    print(select_location(date))
