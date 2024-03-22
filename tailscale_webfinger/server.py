import os

from flask import abort, request, Flask

ISSUER_URL = os.getenv('TW_ISSUER_URL')
if ISSUER_URL is None:
    raise EnvironmentError('Unable to find Issuer URL from env.')

app = Flask(__name__)

@app.route('/.well-known/webfinger', methods=['GET'])
def oidc_webfinger_response():
    if 'resource' not in request.args:
        abort(404)
    email_address = request.args['resource'].replace('acct:', '')
    return {
        "subject": f"acct:{email_address}",
        "links": [
            {
            "rel": "http://openid.net/specs/connect/1.0/issuer",
            "href": f"{ISSUER_URL}"
            }
        ]
    }
