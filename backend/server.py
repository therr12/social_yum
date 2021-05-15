import os

from flask import Flask, request, make_response, jsonify
import firebase_admin
from google.cloud import firestore


app = Flask(__name__)

def get_chowwow(id_) -> firestore.DocumentSnapshot:
  return firestore.Client().collection('chowwows').document(id_).get()


def put_chowwow(owner) -> firestore.DocumentReference:
  _, doc = firestore.Client().collection('chowwows').add({'users': [owner]})
  return doc


@app.route("/api/v1/chowwow", methods=['PUT', 'GET'])
def hello_world():
    # TODO: Verify auth.
    default_app = firebase_admin.initialize_app()
    # decoded_token = auth.verify_id_token(id_token)
    uid = request.args('uid')
    if request.method == 'PUT':
        return make_response(jsonify(put_chowwow(uid).get().to_dict()), 200)
    elif request.method == 'GET':
        id_ = request.args('id')
        if id_ is None:
            return make_response('Missing required "id" param', 400)
        return make_response(jsonify(get_chowwow(id_).to_dict()), 200)
    else:
        raise NotImplementedError


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
