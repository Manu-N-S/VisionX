from flask import Flask, request, jsonify
import ollama


app = Flask(__name__)


@app.route('/process_image_and_text', methods=['POST'])
def process_image_and_text():
   
    data = request.json
    print(data)
    
   
    image = data.get('image', None)
    text = data.get('text', None)
  
    if image is None or text is None:
        return jsonify({'error': 'Image or text missing in request'}), 400
    
    res = ollama.chat(
        model="llava",
        messages=[
            {
                'role': 'user',
                'content': text,
                'images': [image]
            }
        ]
    )
    
    # Extract and return the response
    output = res['message']['content']
    return jsonify({'output': output}), 200

if __name__ == '__main__':
    app.run(debug=True,host ="0.0.0.0")
