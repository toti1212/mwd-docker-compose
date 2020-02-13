import os

from flask import Flask
from redis import Redis

app = Flask(__name__)
redis = Redis(host='redis', port=6379)


@app.route('/')
def hello():
    redis.incr('hits')
    app.logger.debug("Un logger que debería de apagar")
    return f"Hola Montevideo Web Developers x{int(redis.get('hits'))}⚡️"


if __name__ == '__main__':
    app.run(host="0.0.0.0", debug=os.environ.get('DEBUGER', True))
