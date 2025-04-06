from flask import Flask, request, jsonify
from flask_cors import CORS
import mysql.connector
from utils.email_utils import EmailVerification
from utils.drive_utils import GoogleDriveHandler
import os
from dotenv import load_dotenv
import jwt
from datetime import datetime, timedelta

load_dotenv()

app = Flask(__name__)
CORS(app)

# Initialize utilities
email_verification = EmailVerification()
drive_handler = GoogleDriveHandler()

# Database configuration
db_config = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'user': os.getenv('DB_USER'),
    'password': os.getenv('DB_PASSWORD'),
    'database': os.getenv('DB_NAME')
}

def get_db_connection():
    return mysql.connector.connect(**db_config)

@app.route('/api/register', methods=['POST'])
def register():
    data = request.json
    email = data.get('email')
    password = data.get('password')
    role = data.get('role')  # 'admin', 'faculty', or 'student'
    
    if not email or not password:
        return jsonify({'success': False, 'message': 'Email and password are required'}), 400

    # Send verification code
    success, message = email_verification.send_verification_email(email)
    if not success:
        return jsonify({'success': False, 'message': message}), 500

    return jsonify({'success': True, 'message': 'Verification code sent'}), 200

@app.route('/api/verify-email', methods=['POST'])
def verify_email():
    data = request.json
    email = data.get('email')
    code = data.get('code')
    
    success, message = email_verification.verify_code(email, code)
    if not success:
        return jsonify({'success': False, 'message': message}), 400

    # Create user in database
    conn = get_db_connection()
    cursor = conn.cursor()
    
    try:
        cursor.execute(
            "INSERT INTO users (email, password, role, is_verified) VALUES (%s, %s, %s, %s)",
            (email, password, role, True)
        )
        conn.commit()
        return jsonify({'success': True, 'message': 'Email verified and account created'}), 200
    except Exception as e:
        return jsonify({'success': False, 'message': str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@app.route('/api/login', methods=['POST'])
def login():
    data = request.json
    email = data.get('email')
    password = data.get('password')
    
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    try:
        cursor.execute(
            "SELECT * FROM users WHERE email = %s AND password = %s",
            (email, password)
        )
        user = cursor.fetchone()
        
        if not user:
            return jsonify({'success': False, 'message': 'Invalid credentials'}), 401
        
        # Send verification code for login
        success, message = email_verification.send_verification_email(email)
        if not success:
            return jsonify({'success': False, 'message': message}), 500
            
        return jsonify({'success': True, 'message': 'Verification code sent'}), 200
    finally:
        cursor.close()
        conn.close()

@app.route('/api/verify-login', methods=['POST'])
def verify_login():
    data = request.json
    email = data.get('email')
    code = data.get('code')
    
    success, message = email_verification.verify_code(email, code)
    if not success:
        return jsonify({'success': False, 'message': message}), 400

    # Generate JWT token
    token = jwt.encode(
        {
            'email': email,
            'exp': datetime.utcnow() + timedelta(days=1)
        },
        os.getenv('JWT_SECRET'),
        algorithm='HS256'
    )
    
    return jsonify({
        'success': True,
        'message': 'Login successful',
        'token': token
    }), 200

@app.route('/api/upload-file', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return jsonify({'success': False, 'message': 'No file provided'}), 400
        
    file = request.files['file']
    if file.filename == '':
        return jsonify({'success': False, 'message': 'No file selected'}), 400

    # Save file temporarily
    temp_path = f"temp_{file.filename}"
    file.save(temp_path)
    
    try:
        # Upload to Google Drive
        success, result = drive_handler.upload_file(temp_path, file.filename)
        if not success:
            return jsonify({'success': False, 'message': result}), 500
            
        # Get sharing URL
        success, url = drive_handler.get_file_url(result)
        if not success:
            return jsonify({'success': False, 'message': url}), 500
            
        return jsonify({
            'success': True,
            'message': 'File uploaded successfully',
            'file_id': result,
            'url': url
        }), 200
    finally:
        # Clean up temporary file
        if os.path.exists(temp_path):
            os.remove(temp_path)

if __name__ == '__main__':
    app.run(debug=True) 