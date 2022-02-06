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

ocr = ""

model = "weightsnew.hdf5"
plate_det_mask = "plate_weight.xml"

tess.pytesseract.tesseract_cmd = r'C:\Users\Japman\Desktop\Maj\MajorProject\ML_Detection\Tesseract-OCR\tesseract.exe'
cap = cv2.VideoCapture(0)

def fbase(num_plt):

    print("OCR Successful, Firebase called")
    print("Uploading to firebase")
    print("Welcome to Automated Parking")

    num_plt=num_plt.replace(" ","")
    cred = credentials.Certificate("./serviceAccountKey.json")
    app = firebase_admin.initialize_app(cred)
    db = firestore.client()
    user_id = ''
    print(num_plt)
    docs = db.collection('number_plate').where(num_plt, '==', num_plt).limit(1).stream()
    print(docs)
    for doc in docs:
        print(f'{doc.id} => {doc.to_dict()}')
        user_id = doc.id
        print(user_id)
    #adding first data

    doc_ref = db.collection('logs').document(user_id).collection('logs').document('Q12w'+num_plt)
    # Entry
    doc_ref.set({
        'entry_timestamp' : str(datetime.datetime.now()),
        'exit_timestamp' : '',
        'number_plate': num_plt ,
        'place':'Central Mall',
        'paid':''
    })

    # cv2.putText(frame, "Successful, uploading to firebase", (x+w,y+h+40), cv2.FONT_HERSHEY_SIMPLEX,0.5, color3, 2)
    # cv2.putText(frame, "Welcome to Automated Parking", (x,y+h+40), cv2.FONT_HERSHEY_SIMPLEX,0.5, color3, 2)
    # cv2.putText(frame, ocr, (x,y+h+60), cv2.FONT_HERSHEY_SIMPLEX,0.5, color3, 2)

while True:

    _, frame = cap.read()
    blurred_frame = cv2.GaussianBlur(frame, (5, 5), 0)
    hsv = cv2.cvtColor(blurred_frame, cv2.COLOR_BGR2HSV)
    offset = 15
    lower_white = np.array([0,0,255-offset])
    upper_white = np.array([255,offset,255])

    mask = cv2.inRange(hsv, lower_white, upper_white)

    contours, _ = cv2.findContours(mask, cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)
    color1 = (255, 0, 0)
    color2 = (0, 255, 255)
    color3 = (0, 0, 255)


    max_area=0
    for contour in contours:
        #print(contour)
        area = cv2.contourArea(contour)
        if area>max_area and area>8500:
            (x, y, w, h) = cv2.boundingRect(contour)
            cv2.rectangle(frame, (x, y), (x + w, y + h), (0, 0, 255), 2)
            cv2.rectangle(mask, (x, y), (x + w, y + h), (0, 0, 255), 2)

            #cv2.drawContours(frame, contour, -1, (255, 0, 0), 3)
            cv2.putText(frame, "Plate detected", (x+w,y+h), cv2.FONT_HERSHEY_SIMPLEX,0.5, color1, 2)
            cv2.putText(frame, "Applying OCR", (x+w,y+h+20), cv2.FONT_HERSHEY_SIMPLEX,0.5, color2, 2)
            buffer = 0
            crop_ocr = Image.fromarray(frame[x - buffer : x+w+buffer, y- buffer: y+h+buffer])
            full_ocr = Image.fromarray(frame)
            found=False

            try:
                #print("Waiting for Tesseract response")
                text1=tess.image_to_string(crop_ocr)
                #print("1: ",text1)
                check1=re.findall(r"[D-H][L-R]\s*[A-Z0-9]+\s*[A-Z0-9]+\s*[0-9]{4}",text1)
                text2=tess.image_to_string(full_ocr)
                #print("2: ",text2)
                check2=re.findall( r"[D-H][L-R]\s*[A-Z0-9]+\s*[A-Z0-9][A-Z]\s*[0-9]{4}",text2)
                if check1 or check2:
                    if len(check1) <= len(check2):
                        found = True
                        cv2.destroyAllWindows()
                        print("ocr variable value check2 - ",check2)
                        print("OCR Successful, Firebase called")
                        print("Uploading to firebase")
                        print("Welcome to Automated Parking")
                        #fbase(str(check2[0]))
                        #check2 = check2.replace(" ","")



                    else:
                        found = True
                        cv2.destroyAllWindows()
                        print("ocr variable value check1 - ",check1)
                        print("OCR Successful, Firebase called")
                        print("Uploading to firebase")
                        print("Welcome to Automated Parking")
                        #fbase(check1)
                    found = True
                #print(ocr)
                if found==True:
                    cv2.putText(frame, "Successful, uploading to firebase", (x+w,y+h+40), cv2.FONT_HERSHEY_SIMPLEX,0.5, color3, 2)
                    cv2.putText(frame, "Welcome to Automated Parking", (x,y+h+40), cv2.FONT_HERSHEY_SIMPLEX,0.5, color3, 2)
                    cv2.putText(frame, ocr, (x,y+h+60), cv2.FONT_HERSHEY_SIMPLEX,0.5, color3, 2)
                else:
                    try:
                        model.detect(plate)
                        plate_det_mask.apply()
                    except:
                        break
                    break

            except:
                break
                print("OCR Failed")
            max_area=area

    cv2.imshow("Plate Detector", frame)
    cv2.imshow("OCR Detector", mask)
    key = cv2.waitKey(1)
    if key == 27:
        cv2.waitKey(0)
        break

cap.release()
cv2.destroyAllWindows()
