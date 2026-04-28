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
