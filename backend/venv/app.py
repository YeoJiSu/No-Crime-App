from flask import Flask
import flask_restful as flask_restful
from flask_restful import Api
from crime import District, Population, Place, Time, Day, PredictCrime
from search import SearchCrime, Year
from example import Example
app = Flask(__name__)
api = Api(app)

api.add_resource(Example, '/')
api.add_resource(District, '/district/')
api.add_resource(Population, '/population/')
api.add_resource(Place,'/place/')
api.add_resource(Time,'/time/')
api.add_resource(Day, '/day/')
api.add_resource(PredictCrime,'/predict/')
api.add_resource(SearchCrime,'/search/')
api.add_resource(Year,'/year/')

if __name__ == '__main__':
    app.run('0.0.0.0', port=8080, debug=True)