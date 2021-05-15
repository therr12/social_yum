import os

from flask import Flask, request, make_response, jsonify
import firebase_admin
from google.cloud import firestore


app = Flask(__name__)
default_app = firebase_admin.initialize_app()


def get_chowwow(id_) -> firestore.DocumentSnapshot:
  return firestore.Client().collection('chowwows').document(id_).get()


def add_chowwow_user(id_, user) -> firestore.DocumentReference:
  foo = firestore.Client().collection('chowwows').document(id_).get()
  users = foo.get('users')
  if user in users:
      return foo
  users.append(user)
  foo.reference.update({'users': users})
  return foo.reference.get()


def put_chowwow(owner) -> firestore.DocumentReference:
  _, doc = firestore.Client().collection('chowwows').add({'users': [owner]})
  return doc.get()


def _with_id(doc):
  data = doc.to_dict()
  data.update({'id': doc.id})
  return data


@app.route("/api/v1/chowwow", methods=['PUT', 'PATCH', 'GET'])
def chowwow():
    # TODO: Verify auth.
    # decoded_token = auth.verify_id_token(id_token)
    uid = request.args.get('uid')
    if uid is None:
      return make_response('Missing user ID', 401)
    if request.method == 'PUT':
        return make_response(jsonify(_with_id(put_chowwow(uid))), 200)
    elif request.method == 'PATCH':
        id_ = request.args.get('id')
        if id_ is None:
            return make_response('Missing required "id" param', 400)
        return make_response(jsonify(_with_id(add_chowwow_user(id_, uid))), 200)
    elif request.method == 'GET':
        id_ = request.args.get('id')
        if id_ is None:
            return make_response('Missing required "id" param', 400)
        return make_response(jsonify(_with_id(get_chowwow(id_))), 200)
    else:
        raise NotImplementedError


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
