import functools
import json
import os

from flask import Flask, request, make_response, jsonify
import firebase_admin
from firebase_admin import auth
import googlemaps
from google.cloud import firestore
from google.cloud import secretmanager_v1

app = Flask(__name__)
default_app = firebase_admin.initialize_app()
maps_api_key = secretmanager_v1.SecretManagerServiceClient().access_secret_version(request={'name': "projects/chowwow/secrets/google-maps-api-key/versions/latest"}).payload.data.decode('utf8')


def get_chowwow(id_) -> firestore.DocumentSnapshot:
    return firestore.Client().collection("chowwows").document(id_).get()


def add_chowwow_user(id_, user):
    ref = firestore.Client().collection("chowwows").document(id_)
    ref.set({"users": [user]}, merge=True)
    return ref.get()


def put_chowwow(owner) -> firestore.DocumentReference:
    _, doc = firestore.Client().collection("chowwows").add({"users": [owner]})
    return doc.get()


def get_survey(cid, uid) -> firestore.DocumentSnapshot:
    id_ = f"{cid}#{uid}"
    return firestore.Client().collection("surveys").document(id_).get()


def put_survey(cid, uid, questions=None, responses=None) -> firestore.DocumentSnapshot:
    id_ = f"{cid}#{uid}"
    s = firestore.Client().collection("surveys").document(id_)
    data = {"chowwow": cid, "user": uid}
    if questions is not None:
        data["questions"] = questions
    if responses is not None:
        data["responses"] = responses
    s.set(data, merge=True)
    return s.get()


def _with_id(doc):
    if not doc.exists:
        return None
    data = doc.to_dict()
    data.update({"id": doc.id})
    return data


def authenticated(func):
    @functools.wraps(func)
    def wrapped(*a, **k):
        token = request.args.get("token")
        if token is None:
            return make_response("Missing user auth token", 401)
        decoded_token = auth.verify_id_token(token)
        return func(decoded_token, *a, **k)

    return wrapped


def allow_origins(origins):
    def decorator(func):
        @functools.wraps(func)
        def wrapped(*a, **k):
            if request.method == "OPTIONS":
                res = make_response()
                res.headers.add("Access-Control-Allow-Methods", "*")
                res.headers.add("Access-Control-Allow-Headers", "*")
            else:
                res = func(*a, **k)
            origin = request.headers.get("Origin")
            res.headers.add(
                "Access-Control-Allow-Origin", origin if origin in origins else "null"
            )
            return res

        return wrapped

    return decorator


@app.route("/api/v1/chowwow", methods=["PUT", "PATCH", "GET", "OPTIONS"])
@allow_origins(["https://chowwow.web.app", "https://chowwow.app"])
@authenticated
def chowwow(token):
    uid = token["uid"]
    if request.method == "PUT":
        return make_response(jsonify(_with_id(put_chowwow(uid))), 200)
    elif request.method == "PATCH":
        id_ = request.args.get("id")
        if id_ is None:
            return make_response('Missing required "id" param', 400)
        return make_response(jsonify(_with_id(add_chowwow_user(id_, uid))), 200)
    elif request.method == "GET":
        id_ = request.args.get("id")
        if id_ is None:
            return make_response('Missing required "id" param', 400)
        return make_response(jsonify(_with_id(get_chowwow(id_))), 200)
    else:
        raise NotImplementedError


def generate_survey(cid, uid):
    # TODO: Do something based on user preferences or local restaurants..
    return [
        {
            "question": "How much do you care about ratings?",
            "choices": ["I'm a Kenny", "I'm an Eliza"],
        },
        {
            "question": "What are you most likely to order at a restaurant?",
            "choices": ["My go-to", "Something new"],
        },
        {
            "question": "What are you more in the mood for?",
            "choices": ["Fast Food", "Local Eats"],
        },
        {
            "question": "What are you craving?",
            "choices": ["Italian", "American", "Thai"],
        },
    ]


@app.route("/api/v1/chowwow/<cid>/survey", methods=["GET", "PATCH", "POST", "OPTIONS"])
@allow_origins(["https://chowwow.web.app", "https://chowwow.app"])
@authenticated
def survey(token, cid):
    uid = token["uid"]
    if not get_chowwow(cid).exists:
        return make_response("Chowwow does not exist", 404)
    if request.method == "POST":
        return make_response(
            jsonify(
                _with_id(
                    put_survey(
                        cid, uid, questions=generate_survey(cid, uid), responses=[]
                    )
                )
            ),
            200,
        )
    elif request.method == "PATCH":
        responses = request.args.get("responses")
        if responses is None:
            return make_response("Missing responses", 401)
        try:
            parsed_responses = json.loads(responses)
        except json.JSONDecodeError:
            return make_response("Invalid JSON for responses", 400)
        else:
            return make_response(
                jsonify(_with_id(put_survey(cid, uid, responses=parsed_responses))), 200
            )
    elif request.method == "GET":
        return make_response(jsonify(_with_id(get_survey(cid, uid))), 200)


@app.route("/api/v1/chowwow/<cid>/survey/all")
@allow_origins(["https://chowwow.web.app", "https://chowwow.app"])
@authenticated
def list_survey(token, cid):
    uid = token["uid"]
    if not get_chowwow(cid).exists:
        return make_response("Chowwow does not exist", 404)
    return make_response(
        jsonify(
            list(
                map(
                    _with_id,
                    firestore.Client()
                    .collection("surveys")
                    .where("chowwow", "==", cid)
                    .stream(),
                )
            )
        )
    )


@app.route("/api/v1/locations")
@allow_origins(["https://chowwow.web.app", "https://chowwow.app"])
def foo():
    client = googlemaps.Client(key=maps_api_key, retry_timeout=60*60, retry_over_query_limit=False)

    resp = client.places(query="restaurant", location=[40.600884, -111.794177], radius=15*1600, type='restaurant')
    return make_response(jsonify(resp), 200)


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
