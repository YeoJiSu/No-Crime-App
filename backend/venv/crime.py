from flask_restful import reqparse, Resource
import numpy as np
import pickle as p
import pandas
import json
from sklearn.preprocessing import LabelEncoder

class District(Resource): 
    # 도/특별시/광역시 조회
    def get(self):
        distinct_1= json.load(open('file/district.json', 'rb'))
        keys = [key for key in distinct_1]
        return {"data":keys}
    
    # 시/군/구 조회
    def post(self):
        parser = reqparse.RequestParser()
        parser.add_argument('도.특별시.광역시')
        args = parser.parse_args()
        argument = args['도.특별시.광역시']
        distinct_1= json.load(open('file/district.json', 'rb'))
        try:
            data = distinct_1[argument]
            return {"data": data}
        except:
            return {"message": "json으로 전달되는 body 형식이 잘못되었습니다."}

# 인구수 조회 api
class Population(Resource): 
    def post(self):
        parser = reqparse.RequestParser()
        parser.add_argument('도.특별시.광역시')
        parser.add_argument('시.군.구')
        args = parser.parse_args()
        argument_1 = args['도.특별시.광역시']
        argument_2 = args['시.군.구']
        population= json.load(open('file/population.json', 'rb'))
        
        big_city = ["서울특별시","부산광역시","인천광역시","대구광역시","광주광역시","대전광역시","울산광역시"]
        small_city = ["부천","수원","성남","전주","안양","청주","창원","광명","포항","안산","진주","고양",
                      "제주","목포","의정부","익산","군산","구미","천안","여수","춘천","원주","평택",
                      "경주","김해","순천","군포","남양주","강릉","충주","안동","경산","아산","거제",
                      "김천","정읍","용인","시흥","파주","양산","이천","구리","서산","제천","논산"]

        
        try:
            district = argument_1
            if argument_1 in big_city:
                if argument_2 == "전체":
                    district = argument_1[0:2]
                else:
                    district = argument_1[0:2]+argument_2
            elif argument_1 == "세종특별자치시":
                district = "기타 도시"
            else:
                district = argument_2[:-1]
                if district not in small_city:
                    district = "기타 도시"
                
            number = population[district]
            data = {
                "위치": district,
                "인구수": number
            }
            return {"data": data}
        except:
            return {"message": "json으로 전달되는 body 형식이 잘못되었습니다."}

class Place(Resource):
    def get(self):
        data = ['아파트ㆍ연립ㆍ다세대',	'단독주택',	'노상',	'숙박업소ㆍ 목욕탕', '유흥접객업소', '사무실', '공장']
        return {"data": data}
class PredictCrime(Resource):
    def z_transform(self, X, mu, std):
        """
        ==========================
        | X: df, mu: df, std: df |
        ==========================
        """
        return (X-mu)/(std+0.000001)

    def inv_z_transform(self, y, mu, std):
        """
        ====================================
        | y: ndarray, mu: df, std: df      |
        ====================================
        """
        return y * (std+0.000001) + mu


    def post(self):
        region = LabelEncoder()
        place = LabelEncoder()
        day = LabelEncoder()
        time = LabelEncoder()
        region.classes_ = np.load('file/region.npy', allow_pickle=True)
        place.classes_ = np.load('file/place.npy', allow_pickle=True)
        day.classes_ = np.load('file/day.npy', allow_pickle=True)
        time.classes_ = np.load('file/time.npy', allow_pickle=True)
        x_td_mu,x_td_std,y_td_mu,y_td_std = np.load('file/new_x_y_mu_std.npy',allow_pickle=True)
        model = p.load(open('file/linear.pickle', 'rb'))
        
        # 위치,	장소, 요일, 시간대,	인구수
        parser = reqparse.RequestParser()
        parser.add_argument('위치')
        parser.add_argument('장소')
        parser.add_argument('요일')
        parser.add_argument('시간대')
        parser.add_argument('인구수')
        
        # creates dict
        args = parser.parse_args()
        
        try:
            X_new = np.array([
                int(region.transform([args['위치']])[0]),
                int(place.transform([args['장소']])[0]),
                int(day.transform([args['요일']])[0]),
                int(time.transform([args['시간대']])[0]),
                int(args['인구수'])
            ])
        
            X_new = self.z_transform(X_new, x_td_mu, x_td_std).reshape(1, -1)
            
            prediction = self.inv_z_transform(model.predict(X_new), y_td_mu, y_td_std)
    
            prediction = prediction.round(3)
        
            out = {'절도': prediction[0][0],
                '살인': prediction[0][1],
                '강도': prediction[0][2],
                '성폭력': prediction[0][3],
                '폭행': prediction[0][4]}
        
            return {"data": out}, 200
        except:
            return {"message": "json으로 전달되는 body 형식이 잘못되었습니다."}