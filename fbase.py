import firebase_admin
from firebase_admin import credentials, firestore
import datetime

cred = credentials.Certificate("./serviceAccountKey.json")
app = firebase_admin.initialize_app(cred)

db = firestore.client()

user_id = ''

# Japman - 104885248578748957962
# Japneet - 102559740660975769254

num_plt = ""

# => returns user id to corresponding number plate
docs = db.collection('number_plate').where(num_plt, '==', num_plt).limit(1).stream()

for doc in docs:
    print(f'{doc.id} => {doc.to_dict()}')
    user_id = doc.id
    print(user_id)


#adding first data
doc_ref = db.collection('logs').document(user_id).collection('logs').document('Q12w'+num_plt)


doc_ref.set({
    'entry_timestamp' : str(datetime.datetime.now()),
    'exit_timestamp' : '',
    'number_plate': num_plt ,
    'place':'Central Mall1',
    'paid':''
})

print("Success")
