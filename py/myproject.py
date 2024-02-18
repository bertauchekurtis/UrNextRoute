from flask import Flask
from werkzeug.middleware.proxy_fix import ProxyFix
app = Flask(__name__)
app.wsgi_app = ProxyFix(app.wsgi_app, x_for=1, x_host=1)

@app.route("/")
def home():
    return "<h1 style='color:blue'>hello worlds!</h1>"

@app.route('/json')
def json():
    return {
        "status": "hello world",
        "color": "green",
    }

if __name__ == "__main__":
    app.run(host='0.0.0.0')