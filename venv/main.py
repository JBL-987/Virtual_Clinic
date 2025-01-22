import logging
import ollama
import base64
import tempfile
import io
from flask import Flask, request, jsonify
from flask_cors import CORS
from PIL import Image
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Setup logging
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Initialize Flask app
app = Flask(__name__)
CORS(app, origins= '*')

def process_image(base64_image):
    """Process base64 encoded image and save it temporarily"""
    try:
        # Decode base64 image
        image_data = base64.b64decode(base64_image)
        image = Image.open(io.BytesIO(image_data))
        
        # Create temporary file
        with tempfile.NamedTemporaryFile(delete=False, suffix='.png') as temp_file:
            image.save(temp_file.name)
            return temp_file.name
    except Exception as e:
        logger.error(f"Error processing image: {str(e)}")
        raise

def cleanup_temp_file(file_path):
    """Clean up temporary image file"""
    try:
        if file_path and os.path.exists(file_path):
            os.unlink(file_path)
    except Exception as e:
        logger.error(f"Error cleaning up temp file: {str(e)}")

def get_medical_context():
    """Return the medical context prompt for the AI"""
    return """You are a helpful medical assistant. Your role is to:
1. Listen carefully to patient symptoms
2. Ask relevant follow-up questions if needed
3. Provide general health information and guidance
4. ALWAYS remind patients to consult with a qualified healthcare professional for proper diagnosis and treatment
5. When analyzing images, focus on visible symptoms but emphasize the importance of professional medical evaluation
Remember: Do not make definitive diagnoses. Provide information while emphasizing the importance of professional medical consultation."""

@app.route('/api/chat', methods=['POST'])
def chat_with_gemma():
    try:
        logger.info("Received POST request on /api/chat")
        data = request.get_json()
        logger.debug(f"Request body: {data}")

        messages = data.get('messages', [])
        if not messages:
            logger.warning("No messages found in request")
            return jsonify({'error': 'No messages provided'}), 400

        current_message = messages[-1] 
        temp_image_path = None
        conversation = [
            {'role': 'system', 'content': get_medical_context()}
        ]
        for msg in messages[:-1]:
            conversation.append({
                'role': msg.get('role', 'user'),
                'content': msg.get('content', '')
            })

        try:
            if 'image' in current_message:
                logger.info("Processing image message")
                temp_image_path = process_image(current_message['image'])
                image_prompt = (
                    "Please analyze this medical image and describe what you observe. "
                    "Remember to be cautious and emphasize the need for professional medical evaluation."
                )
                
                response_stream = ollama.chat(
                    model='deepseek-r1',
                    messages=[{
                        'role': 'user',
                        'content': image_prompt
                    }],
                    images=[temp_image_path],
                    stream=True
                )
            else:
                conversation.append({
                    'role': current_message.get('role', 'user'),
                    'content': current_message.get('content', '')
                })
                
                response_stream = ollama.chat(
                    model='deepseek-r1',
                    messages=conversation,
                    stream=True
                )

            full_response = ""
            for chunk in response_stream:
                if 'message' in chunk:
                    content = chunk['message']['content']
                    logger.debug(f"Received chunk: {content}")
                    full_response += content

            logger.info(f"AI response: {full_response}")
            return jsonify({
                'message': {
                    'content': full_response
                }
            })

        except Exception as e:
            logger.error(f"Error in chat processing: {str(e)}")
            return jsonify({'error': f'Error processing request: {str(e)}'}), 500

        finally:
            if temp_image_path:
                cleanup_temp_file(temp_image_path)

    except Exception as e:
        logger.error(f"Error during chat interaction: {str(e)}")
        return jsonify({'error': str(e)}), 500

if __name__ == "__main__":
    logger.info("Starting backend server...")
    app.run(debug=True, host='0.0.0.0', port=11434)