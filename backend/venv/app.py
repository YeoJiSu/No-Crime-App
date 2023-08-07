from flask import Flask
import flask_restful as flask_restful
from flask_restful import Api
from crime import HelloWorld, PredictCrime
from search import AdministrativeDistrict

app = Flask(__name__)
api = Api(app)

api.add_resource(HelloWorld, '/')
api.add_resource(PredictCrime,'/predict/')
api.add_resource(AdministrativeDistrict, '/search/')

if __name__ == '__main__':
    app.run('0.0.0.0', port=8080, debug=True)