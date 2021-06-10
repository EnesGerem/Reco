from flask import Flask, request
from flask_restful import Api, Resource, reqparse
import werkzeug
from flask import send_file
from PIL import Image
from prediction import pred

app = Flask(__name__)

api = Api(app)


class Application(Resource):
    def get(self):
        return {'about': 'MERHABALAR'}

    def post(self):
        parse = reqparse.RequestParser()
        parse.add_argument(
            'file', type=werkzeug.datastructures.FileStorage, location='files')
        args = parse.parse_args()
        image_file = args['file']
        # image_file.save("anan.jpg")

        pred(image_file)
        return {"prediction": "Jacket"}


api.add_resource(Application, '/')


if __name__ == '__main__':
    app.run(debug=True)
