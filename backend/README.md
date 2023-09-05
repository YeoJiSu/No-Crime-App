# No-crime Rest API

* 배포된 document 보기: https://documenter.getpostman.com/view/15493095/2s9Y5eNKbV

### 주요 기능
1. 범죄 관련 데이터 조회
   * `POST /population/`  body로 지역을 전송해서 지역별 인구수를 조회
   * `GET /place/`  장소 list 조회
   * `GET /time/`  시간 list 조회
   * `GET /day/`  요일 list 조회
   * `GET /year/`  연도 list 조회
   * `GET /district/` 도.특별시.광역시 list 조회
   * `POST /district/` body로 도.특별시.광역시를 전송해서 시.군.구 list를 조회

2. 범죄 예측
   * `POST /predict/` body로 위치, 장소, 요일, 시간대, 인구수를 전송해서 5대 범죄별 범죄 안전도를 조회
   
3. 범죄 건수 조회
   * `POST /search/` body로 도.특별시.광역시, 시.군.구, 연도를 전송해서 해당 연도에 해당되는 지역의 범죄 건수를 조회
