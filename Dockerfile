FROM hshar/flaskapp
RUN apt-get update -y && \
    apt-get install -y git
RUN git clone https://github.com/jashwaaradhya/flask-sample.git
WORKDIR /flask-sample
CMD [ "python3", "./hello.py" ]
