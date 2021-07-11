import firebase_admin
import google.cloud
from firebase_admin import credentials, firestore
import datetime;

cred = credentials.Certificate("./serviceAccountKey.json")
app = firebase_admin.initialize_app(cred)

db = firestore.client()

user_id = ''    

# Japman - 104885248578748957962
# Japneet - 102559740660975769254

num_plt = 'DL8CAK6278' #DL7BNH9510
# 1. DL8CAT9393 
# 2. DL12CE7693
# 3. 
# 4. DL8CAK6278

# => returns user id to corresponding number plate
docs = db.collection('number_plate').where(num_plt, '==', num_plt).limit(1).stream()

for doc in docs:
    print(f'{doc.id} => {doc.to_dict()}')
    user_id = doc.id
    print(user_id)
    

#adding first data
doc_ref = db.collection('logs').document(user_id).collection('logs').document('Q12w'+num_plt)
 
# ************************----- On Entrance: -----***************************


# doc_ref.set({
#     'entry_timestamp' : str(datetime.datetime.now()),
#     'number_plate': num_plt ,
#     'place':'Central Mall1',
# })


# *************************----- End Entrance: -----*************************


# ************************----- On Exit: -----*******************************


doc_ref.update({
    'exit_timestamp' : str(datetime.datetime.now()),
})

doc_ref_log = db.collection('logs').document(user_id).collection('recentLogs')

doc_ref_details = doc_ref.get()

print('=> {} '.format(doc_ref_details.to_dict()))

doc_ref_log.add(doc_ref_details.to_dict())


# **************************----- End Exit: -----**********************************

print(str(datetime.datetime.now())[0:10])
print(str(datetime.datetime.now())[11:19])

print("Success")