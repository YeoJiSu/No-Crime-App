from flask import Flask
from flask_restful import reqparse
import numpy as np
import pandas
import pickle as p
import json
from sklearn.preprocessing import LabelEncoder
import numpy
import pickle
app = Flask(__name__)

def z_transform(X, mu, std):
    """
    ==========================
    | X: df, mu: df, std: df |
    ==========================
    """
    return (X-mu)/(std+0.000001)

def inv_z_transform(y, mu, std):
    """
    ====================================
    | y: ndarray, mu: df, std: df      |
    ====================================
    """
    return y * (std+0.000001) + mu

@app.route('/')
def home():
    return 'This is home!'

@app.route('/predict/', methods=['POST'])
def predict():
    parser = reqparse.RequestParser()
    # 위치,	장소, 요일, 시간대,	인구수
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
    
    # convert input to array
    #X_new = np.fromiter(args.values(), dtype=float)
    
    
    X_new = z_transform(X_new, x_td_mu, x_td_std).reshape(1, -1)
    prediction = inv_z_transform(model.predict(X_new), y_td_mu, y_td_std)
    # predict - return ndarray
    prediction = prediction.round(3)
    # result
    out = {'절도': prediction[0][0],
           '살인': prediction[0][1],
           '강도': prediction[0][2],
           '성폭력': prediction[0][3],
           '폭행': prediction[0][4]}
    return out, 200


if __name__ == '__main__':
    modelfile = 'model/linear.pickle'
    model = p.load(open(modelfile, 'rb'))
    region = LabelEncoder()
    region.classes_ = numpy.load('model/region.npy', allow_pickle=True)
    place = LabelEncoder()
    place.classes_ = numpy.load('model/place.npy', allow_pickle=True)
    day = LabelEncoder()
    day.classes_ = numpy.load('model/day.npy', allow_pickle=True)
    time = LabelEncoder()
    time.classes_ = numpy.load('model/time.npy', allow_pickle=True)
    x_td_mu,x_td_std,y_td_mu,y_td_std = numpy.load('model/new_x_y_mu_std.npy',allow_pickle=True)
    app.run('0.0.0.0', port=8080, debug=True)