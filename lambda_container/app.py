from typing import Any

import gspread
from oauth2client.service_account import ServiceAccountCredentials
import pandas as pd
import boto3
import json
import os
import traceback
import logging

SSM_CLIENT = boto3.client("ssm")
PARAM_NAME = os.environ.get('CREDENTIALS')
concatenated_data_frame = pd.DataFrame()


def get_google_credential_json():
    response = SSM_CLIENT.get_parameters(
        Names=[
            PARAM_NAME,
        ],
        WithDecryption=True
    )
    return json.loads(response['Parameters'][0]['Value'])

def concatenate_google_spreadsheets(google_cloud_spreadsheets):
    index = 0
    flag = True
    while flag:
        try:
            if index:
                worksheet = google_cloud_spreadsheets.open(f"IFTTT_Maker_Webhooks_Events ({index})").sheet1
            else:
                worksheet = google_cloud_spreadsheets.open(f"IFTTT_Maker_Webhooks_Events").sheet1
        except Exception:
            flag = False
            logging.error(traceback.format_exc())
        else:
            data = worksheet.get_all_values()
            global concatenated_data_frame
            concatenated_data_frame = pd.concat([data_frame, data])
            index = index + 1



def handler(event, context):
    credentials = ServiceAccountCredentials.from_json_keyfile_name(get_google_credential_json())
    google_cloud_spreadsheets = gspread.authorize(credentials)
    concatenate_google_spreadsheets(google_cloud_spreadsheets)

