import requests

from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)


@app.route('/materials', methods=['GET'])
def get_materials():
    host = "http://infinitfytraining.ddns.net:8000"
    resource = "/sap/opu/odata/sap/ZCDS_SP_MATERIAL_CDS/ZCDS_SP_MATERIAL"
    query = "?$select=matnr,matty,mbrsh,price,maktx&$format=json"

    payload = {}
    headers = {
        'Authorization': 'Basic U01FTEdFUzpJbmZpbml0QDAx',
        "Content-Type": "application/json",
    }

    response = requests.request("GET", host + resource + query, headers=headers, data=payload)

    return response.content, response.status_code


if __name__ == '__main__':
    app.run(debug=True)
