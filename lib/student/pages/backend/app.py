from flask import Flask, request, jsonify
import os
from pyresparser import ResumeParser

app = Flask(__name__)

# Modify this to match your asset folder (where uploaded PDFs are saved)
UPLOAD_FOLDER = 'assets/uploads'

# Create the upload folder if it doesn't exist
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

# Import the function to display skills recommendation from resume_parser.py
from resume_parser import display_skills_recommendation
from resume_parser import ratings

def parse_resume(resume_file_path):
    try:
        resume_data = ResumeParser(resume_file_path).get_extracted_data()
        if resume_data:
            # Extract specific fields (modify as needed)
            name = resume_data.get('name', '')
            email = resume_data.get('email', '')
            skills = resume_data.get('skills', [])

            return {'name': name, 'email': email, 'skills': skills}
        else:
            return None
    except Exception as e:
        print(f"Error parsing resume: {e}")
        return None

@app.route('/upload', methods=['POST'])
def upload_file():
    
    if 'file' not in request.files:
        return jsonify({'error': 'No file part'}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    if file:
        filename = file.filename
        file_path = os.path.join(UPLOAD_FOLDER, filename)
        file.save(file_path)
     
        # Call the resume parser function
        resume_data= parse_resume(file_path)
       
        if resume_data:
            
            resume_data['recommended_skills'] = display_skills_recommendation(resume_data)
            print(ratings(resume_data,file_path))
            resume_data['rating'] = ratings(resume_data,file_path)
            #print(jsonify({'message': 'File uploaded successfully', 'resume_data': resume_data}))
            return jsonify({'message': 'File uploaded successfully', 'resume_data': resume_data}), 200
        else:
            return jsonify({'error': 'Failed to parse resume'}), 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
