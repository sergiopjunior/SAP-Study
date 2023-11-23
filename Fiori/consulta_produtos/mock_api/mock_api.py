from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app) 

@app.route('/materials', methods=['GET'])
def get_materials():
    materials = [
        {
            "material_id": "100001",
            "description": "Produto A",
            "active": True,
            "qtde": 9,
            "amount": 100,
            "curr": "BRL",
            "stock": [
                {
                    "armazem_id": "AA",
                    "description": "Armazém A",
                    "qtde": 7,
                    "amount": 77,
                    "curr": "BRL"
                },
                {
                    "armazem_id": "AB",
                    "description": "Armazém B",
                    "qtde": 2,
                    "amount": 23,
                    "curr": "BRL"
                }
            ]
        },
        {
            "material_id": "100002",
            "description": "Produto B",
            "active": False,
            "qtde": 3,
            "amount": 63,
            "curr": "BRL",
            "stock": [
                {
                    "armazem_id": "AA",
                    "description": "Armazém A",
                    "qtde": 1,
                    "amount": 21,
                    "curr": "BRL"
                },
                {
                    "armazem_id": "AC",
                    "description": "Armazém C",
                    "qtde": 2,
                    "amount": 42,
                    "curr": "BRL"
                }
            ]
        }
    ]
    return jsonify({"materials": materials})

if __name__ == '__main__':
    app.run(debug=True)
