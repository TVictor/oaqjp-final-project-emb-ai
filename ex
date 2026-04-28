1a-----
https://github.com/TVictor/oaqjp-final-project-emb-ai/blob/main/README.md

2a_emotion_detection -----
import requests, json

def emotion_detector(text_to_analyse):
    url = 'https://sn-watson-emotion.labs.skills.network/v1/watson.runtime.nlp.v1/NlpService/EmotionPredict'
    header = {"grpc-metadata-mm-model-id": "emotion_aggregated-workflow_lang_en_stock"}
    myobj = { "raw_document": { "text": text_to_analyze } }
    response = requests.post(url, json = myobj, headers=header)
    formatted_response = json.loads(response.text)
    return formatted_response

3a_output_formatting ------

import requests, json

def emotion_detector(text_to_analyze):
    url = 'https://sn-watson-emotion.labs.skills.network/v1/watson.runtime.nlp.v1/NlpService/EmotionPredict'
    header = {"grpc-metadata-mm-model-id": "emotion_aggregated-workflow_lang_en_stock"}
    myobj = { "raw_document": { "text": text_to_analyze } }
    response = requests.post(url, json = myobj, headers=header)
    formatted_response = json.loads(response.text)
    anger_score = formatted_response['emotionPredictions'][0]['emotion']['anger']
    disgust_score = formatted_response['emotionPredictions'][0]['emotion']['disgust']
    fear_score = formatted_response['emotionPredictions'][0]['emotion']['fear']
    joy_score = formatted_response['emotionPredictions'][0]['emotion']['joy']
    sadness_score = formatted_response['emotionPredictions'][0]['emotion']['sadness']
    output = {
    'anger': anger_score,
    'disgust': disgust_score,
    'fear': fear_score,
    'joy': joy_score,
    'sadness': sadness_score,
    'dominant_emotion': '<name of the dominant emotion>'
    }
    dominant_added = determine_dominant_emotion(output)
    return dominant_added

def determine_dominant_emotion(output):
    max_score = 0.0
    max_emotion_key =''
    for key, value in output.items():
        if key!= 'dominant_emotion' and float(value) > max_score:
            max_score = float(value)
            max_emotion_key = key
    
    output['dominant_emotion'] = max_emotion_key
    return output

4b_packaging_test -----

Python 3.11.14 (main, Oct 10 2025, 08:54:03) [GCC 11.4.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> from EmotionDetection import emotion_detection
>>> emotion_detection.emotion_detector('I hate working long hours')
{'anger': 0.64949876, 'disgust': 0.03718168, 'fear': 0.05612277, 'joy': 0.00862553, 'sadness': 0.1955148, 'dominant_emotion': 'anger'}

5b_unit_testing_result ----

python3.11 test_emotion_detection.py 
.
----------------------------------------------------------------------
Ran 1 test in 0.615s

OK

6a_server  -----

from flask import Flask, render_template, request
from EmotionDetection.emotion_detection import emotion_detector

app = Flask("Emotion Detection")

@app.route("/emotionDetector")
def sent_emotion_detector():
    resp = emotion_detector(request.args.get('textToAnalyze'))
    anger = resp['anger']
    disgust = resp['disgust']
    fear = resp['fear']
    joy = resp['joy']
    sadness = resp['sadness']
    dominant = resp['dominant_emotion']
    output = f"For the given statement, the system response is 'anger': {anger}, 'disgust': {disgust}, 'fear': {fear}, 'joy': {joy} and 'sadness': {sadness}. The dominant emotion is {dominant}."
    return output

@app.route("/")
def render_index_page():
    return render_template('index.html')

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

7a_error_handling_function -----

def sent_emotion_detector():
    input_text = request.args.get('textToAnalyze')
    if input_text == None or len(input_text) == 0:
        return {
            'anger': None,
            'disgust': None,
            'fear': None,
            'joy': None,
            'sadness': None,
            'dominant_emotion': None
        }, 400
    resp = emotion_detector(input_text)
    anger = resp['anger']
    disgust = resp['disgust']
    fear = resp['fear']
    joy = resp['joy']
    sadness = resp['sadness']
    dominant = resp['dominant_emotion']
    output = f"For the given statement, the system response is 'anger': {anger}, 'disgust': {disgust}, 'fear': {fear}, 'joy': {joy} and 'sadness': {sadness}. The dominant emotion is {dominant}."
    return output

8a_server_modified ------

''' Executing this function initiates the application of emotion
    detector to be executed over the Flask channel and deployed on
    localhost:5000.
'''
from flask import Flask, render_template, request
from EmotionDetection.emotion_detection import emotion_detector

app = Flask("Emotion Detection")

@app.route("/emotionDetector")
def sent_emotion_detector():
    ''' This code receives the text from the HTML interface and 
        runs emotion detection over it using emotion_detector()
        function. The output returned shows the 5 emotion category scores
        and the dominant emotion.
    '''
    input_text = request.args.get('textToAnalyze')
    if input_text is None or len(input_text) == 0:
        return {
            'anger': None,
            'disgust': None,
            'fear': None,
            'joy': None,
            'sadness': None,
            'dominant_emotion': None
        }, 400
    resp = emotion_detector(input_text)
    anger = resp['anger']
    disgust = resp['disgust']
    fear = resp['fear']
    joy = resp['joy']
    sadness = resp['sadness']
    dominant = resp['dominant_emotion']
    output = f"For the given statement, the system response is \
    'anger': {anger}, 'disgust': {disgust}, 'fear': {fear}, 'joy':\
     {joy} and 'sadness': {sadness}. The dominant emotion is {dominant}."
    return output

@app.route("/")
def render_index_page():
    ''' This function initiates the rendering of the main application
        page over the Flask channel
    '''
    return render_template('index.html')

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
