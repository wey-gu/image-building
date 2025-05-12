# The base image for the backend FROM tiangolo/uvicorn-gunicorn-fastapi:python3.10
# including major dependencies:
# - tiktoken files
# - nltk files
# - poppler-utils
# - Apache Tika

FROM tiangolo/uvicorn-gunicorn-fastapi:python3.10

# Install dependencies
RUN apt-get update && apt-get install -y poppler-utils tzdata tree openjdk-17-jdk && rm -rf /var/lib/apt/lists/* && \
    python3 -m pip install --upgrade pip && \
    python3 -m pip install tiktoken tika nltk torch>=2.4.0 && \
    python3 -c "import tiktoken; tiktoken.encoding_for_model('gpt-3.5-turbo'); tiktoken.get_encoding('gpt2')" && \
    python3 -m nltk.downloader punkt stopwords wordnet averaged_perceptron_tagger punkt_tab && \
    touch /tmp/dummy.txt && echo "dummy" > /tmp/dummy.txt && \
    python3 -c "import tika; tika.initVM(); from tika import parser; parser.from_file('/tmp/dummy.txt')" && \
    rm -f /tmp/dummy.txt /tmp/tika-server.jar.md5 /tmp/tika.log /tmp/tika-server.log

# Command for dual arch build:
# docker buildx build --platform linux/amd64,linux/arm64 -t weygu/uvicorn-gunicorn-fastapi:python3.10 --push -f Dockerfile.base .

# Command for test run it with bash for inspection:
# docker run -it weygu/uvicorn-gunicorn-fastapi:python3.10 bash
# java -version
# python3
# import tika
# tika.initVM()

# TODO: it seems now in arm64, tika is not working, need to find a way to fix it later.
#       ref: https://github.com/abhilesh/apache-tika-arm
