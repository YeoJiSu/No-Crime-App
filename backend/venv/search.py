from flask_restful import reqparse, Resource
from crime import District
import pandas as pd

path = "file/real-crime-data/"

class Year(Resource):
    def get(self):
        data = ["2021","2020","2019","2018","2017","2016","2015","2014"]
        return {"data": data}

class SearchCrime(Resource): 
    def post(self):
        parser = reqparse.RequestParser()
        parser.add_argument('도.특별시.광역시')
        parser.add_argument('시.군.구')
        parser.add_argument('연도')
        
        args = parser.parse_args()
        argument_1 = args['도.특별시.광역시']
        argument_2 = args['시.군.구']
        argument_3 = args['연도']
        
        _year = pd.read_csv(path+argument_3+".csv", index_col = 0)
        
        try:
            district = District().district_name(argument_1, argument_2)
            _crime = _year[[district]].values.reshape(1,-1)[0]
            
            data = {
                "절도": round(_crime[0]),
                "살인": round(_crime[1]),
                "강도": round(_crime[2]),
                "성폭력": round(_crime[3]),
                "폭행": round(_crime[4])
            }
            return {"data": data},200
        
        except:
            return {"message": "json으로 전달되는 body 형식이 잘못되었습니다."}
        
    