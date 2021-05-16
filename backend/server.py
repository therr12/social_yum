import json
import os

from flask import Flask, request, make_response, jsonify
import firebase_admin
from google.cloud import firestore


app = Flask(__name__)
default_app = firebase_admin.initialize_app()


def get_chowwow(id_) -> firestore.DocumentSnapshot:
  return firestore.Client().collection('chowwows').document(id_).get()


def add_chowwow_user(id_, user):
  foo = firestore.Client().collection('chowwows').document(id_).set({'users': [user]}, merge=True)
  return foo.reference.get()


def put_chowwow(owner) -> firestore.DocumentReference:
  _, doc = firestore.Client().collection('chowwows').add({'users': [owner]})
  return doc.get()


def get_survey(cid, uid) -> firestore.DocumentSnapshot:
  id_ = f'{cid}#{uid}'
  return firestore.Client().collection('surveys').document(id_).get()


def put_survey(cid, uid, questions=None, responses=None) -> firestore.DocumentSnapshot:
  id_ = f'{cid}#{uid}'
  s = firestore.Client().collection('surveys').document(id_)
  data = {'chowwow': cid, 'user': uid}
  if questions is not None:
      data['questions'] = questions
  if responses is not None:
      data['responses'] = responses
  s.set(data, merge=True)
  return s.get()


def _with_id(doc):
  if not doc.exists:
    return None
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


def generate_survey(cid, uid):
    return [{'question': 'What do want?', 'choice1': 'Foo', 'choice2': 'Bar'}]*5


@app.route("/api/v1/chowwow/<cid>/survey", methods=['GET', 'PATCH', 'POST'])
def survey(cid):
    # TODO: Verify auth.
    # decoded_token = auth.verify_id_token(id_token)
    uid = request.args.get('uid')
    if uid is None:
      return make_response('Missing user ID', 401)
    if not get_chowwow(cid).exists:
      return make_response('Chowwow does not exist', 404)
    if request.method == 'POST':
        return make_response(jsonify(_with_id(put_survey(cid, uid, questions=generate_survey(cid, uid), responses=[]))), 200)
    elif request.method == 'PATCH':
        responses = request.args.get('responses')
        if responses is None:
          return make_response('Missing responses', 401)
        try:
          parsed_responses = json.loads(responses)
        except json.JSONDecodeError:
          return make_response('Invalid JSON for responses', 400)
        else:
          return make_response(jsonify(_with_id(put_survey(cid, uid, responses=parsed_responses))), 200)
    elif request.method == 'GET':
        return make_response(jsonify(_with_id(get_survey(cid, uid))), 200)


@app.route("/api/v1/chowwow/<cid>/survey/all")
def list_survey(cid):
    # TODO: Verify auth.
    # decoded_token = auth.verify_id_token(id_token)
    uid = request.args.get('uid')
    if uid is None:
      return make_response('Missing user ID', 401)
    if not get_chowwow(cid).exists:
      return make_response('Chowwow does not exist', 404)
    return make_response(jsonify(list(map(_with_id, firestore.Client().collection('surveys').where('chowwow', '==', cid).stream()))))


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
