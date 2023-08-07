from flask_restful import reqparse, Resource
import numpy as np
import pickle as p
import pandas
import json
from sklearn.preprocessing import LabelEncoder

class HelloWorld(Resource):
    def get(self):
        return {'hello': 'world'}

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
        return out, 200