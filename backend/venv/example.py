from flask_restful import Resource
class Example(Resource):
    def get(self):
        out = {'절도': 10,
            '살인': 50,
            '강도': 70,
            '성폭력': 90,
            '폭행': 30}
        
        return {"data": out}, 200