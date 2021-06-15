import cv2
import numpy as np
import time
from time import sleep
from PIL import Image
import pytesseract as tess
import re
import firebase_admin
from firebase_admin import credentials, firestore
import datetime

def fbase(num_plt):

    print("OCR Successful, Firebase called")
    print("Uploading to firebase")
    print("Thank You for using Simply Park")

    num_plt=num_plt.replace(" ","")

    cred = credentials.Certificate("./serviceAccountKey.json")
    app = firebase_admin.initialize_app(cred)
    db = firestore.client()
    user_id = ''
    docs = db.collection('number_plate').where(num_plt, '==', num_plt).limit(1).stream()

    for doc in docs:
        print(f'{doc.id} => {doc.to_dict()}')
        user_id = doc.id
        print(user_id)


    #adding first data
    doc_ref = db.collection('logs').document(user_id).collection('logs').document('Q12w'+num_plt)
    doc_ref.update({
        'exit_timestamp' : str(datetime.datetime.now()),
    })

    doc_ref_log = db.collection('logs').document(user_id).collection(num_plt)

    doc_ref_details = doc_ref.get()

    print('=> {} '.format(doc_ref_details.to_dict()))

    doc_ref_log.add(doc_ref_details.to_dict())

fbase("DL3CAY4296")
