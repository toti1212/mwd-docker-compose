from flask import Flask
app = Flask(__name__)


@app.route('/')
def hello():
    app.logger.debug("Un logger que debería de apagar")
    return "Hello 🇺🇾!"


if __name__ == '__main__':
    app.run()
