import cv2
import numpy as np
import time
from time import sleep
from copy import deepcopy
from PIL import Image
import pytesseract as tess
import re
import firebase_admin
from firebase_admin import credentials, firestore
import datetime

model = "weightsnew.hdf5"
plate_det_mask = "plate_weight.xml"

ocr = ""
cred = credentials.Certificate("./serviceAccountKey.json")
app = firebase_admin.initialize_app(cred)
db = firestore.client()

tess.pytesseract.tesseract_cmd = r'D:\Program Files\Tesseract-OCR\tesseract.exe'
cap = cv2.VideoCapture(0)

def fbase(num_plt):
    user_id = ''
        # => returns user id to corresponding number plate
    docs = db.collection('number_plate').where(num_plt, '==', num_plt).limit(1).stream()
    for doc in docs:
        print(f'{doc.id} => {doc.to_dict()}')
        user_id = doc.id
        print(user_id)
    #adding first data

    doc_ref = db.collection('logs').document(user_id).collection('logs').document('Q12w'+num_plt)
    # ************************----- On Entrance: -----***************************
    doc_ref.set({
        'entry_timestamp' : str(datetime.datetime.now()),
        'number_plate': num_plt ,
        'place':'Central Mall1',
    })
    # *************************----- End Entrance: -----*************************



while True:
    _, frame = cap.read()
    blurred_frame = cv2.GaussianBlur(frame, (5, 5), 0)
    hsv = cv2.cvtColor(blurred_frame, cv2.COLOR_BGR2HSV)
    offset = 15
    lower_white = np.array([0,0,255-offset])
    upper_white = np.array([255,offset,255])
    #lower_white = np.array([0, 0, 0])
    #upper_white = np.array([0, 0, 255])
    mask = cv2.inRange(hsv, lower_white, upper_white)
    #out = np.zeros_like(frame)
    #out[mask == 255] = frame[mask == 255]
    contours, _ = cv2.findContours(mask, cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)
    color1 = (255, 0, 0)
    color2 = (0, 255, 255)
    color3 = (0, 0, 255)

    '''
    idx = ... # The index of the contour that surrounds your object
    mask = np.zeros_like(frame) # Create mask where white is what we want, black otherwise
    cv2.drawContours(mask, contours, idx, 255, -1) # Draw filled contour in mask
    out = np.zeros_like(frame) # Extract out the object and place into output image
    out[mask == 255] = img[mask == 255]
    '''

# Show the output image
    #cv2.imshow('Output', out)
    #cv2.waitKey(0)
    #cv2.destroyAllWindows()


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
                #print(plate_im)
                text1=tess.image_to_string(crop_ocr)
                check1=re.findall(r"[A-Z][A-Z]\s*[A-Z0-9]+\s*[A-Z0-9]+\s*[0-9]{4}",text1)
                text2=tess.image_to_string(full_ocr)
                check2=re.findall( r"[A-Z][A-Z]\s*[A-Z0-9]+\s*[A-Z0-9][A-Z]\s*[0-9]{4}",text2)
                if check1 or check2:
                    if len(check1)<len(check2):
                        found = True
                        #print("Detected Text check : ",check2)
                        ocr = check2
                        ocr = ocr.replace(" ","")
                        ocr = ocr.replace(" ","")
                        #print(ocr)
                        fbase(ocr)
                        print("Firebase 1 Success")
                    else:
                        #print("Detected Text : ",check1)
                        ocr = check1
                        ocr = ocr.replace(" ","")
                        print("else")
                    found = True

                if found==True:
                    cv2.putText(frame, "Successful, uploading to firebase", (x+w,y+h+40), cv2.FONT_HERSHEY_SIMPLEX,0.5, color3, 2)
                    cv2.putText(frame, "Welcome to Simply Park", (x,y+h+40), cv2.FONT_HERSHEY_SIMPLEX,0.5, color3, 2)
                    cv2.putText(frame, ocr, (x,y+h+60), cv2.FONT_HERSHEY_SIMPLEX,0.5, color3, 2)
                else:
                    break


            except:
                break
                print("OCR Failed")
            max_area=area
            #cropped = cap[70:170, 440:540]
            #cv2.imshow("cropped", cropped)
            #cv2.imwrite("plate.png", cropped)
            #cv2.waitKey(0)
            #print(cv2.drawContours(frame, contour, -1, (0, 255, 0), 3))
    cv2.imshow("Plate Detector", frame)
    cv2.imshow("OCR Detector", mask)
    key = cv2.waitKey(1)
    if key == 27:
        cv2.waitKey(0)
        break

cap.release()
cv2.destroyAllWindows()
