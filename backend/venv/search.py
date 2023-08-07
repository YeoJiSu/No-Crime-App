from flask_restful import reqparse, Resource
import json
# 행정구역 선택 api
class AdministrativeDistrict(Resource): 
    # 도/특별시/광역시 조회
    def get(self):
        distinct_1= json.load(open('file/district.json', 'rb'))
        keys = [key for key in distinct_1]
        return {'도.특별시.광역시':keys}
    
    # 시/군/구 조회
    def post(self):
        parser = reqparse.RequestParser()
        parser.add_argument('도.특별시.광역시')
        args = parser.parse_args()
        argument = args['도.특별시.광역시']
        distinct_1= json.load(open('file/district.json', 'rb'))
        try:
            data = distinct_1[argument]
            return {'data': data}
        except:
            return {"message": "json으로 전달되는 body 형식이 잘못되었습니다."}


