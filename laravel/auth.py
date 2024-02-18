from flask import Flask, request, jsonify
import sqlite3
import hashlib
import secrets

app = Flask(__name__)

# Database setup
conn = sqlite3.connect('users.db')
cursor = conn.cursor()
cursor.execute('''CREATE TABLE IF NOT EXISTS users
                (id INTEGER PRIMARY KEY, username TEXT, password_hash TEXT, wallet_address TEXT)''')
conn.commit()

# Function to hash passwords
def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

# Function to generate a random wallet address
def generate_wallet_address():
    return secrets.token_hex(16)

# Register endpoint
@app.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    if not username or not password:
        return jsonify({'error': 'Username and password are required'}), 400

    hashed_password = hash_password(password)
    wallet_address = generate_wallet_address()

    cursor.execute("INSERT INTO users (username, password_hash, wallet_address) VALUES (?, ?, ?)", (username, hashed_password, wallet_address))
    conn.commit()

    return jsonify({'message': 'User registered successfully', 'wallet_address': wallet_address}), 201

# Login endpoint
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    username = data.get('username')
    password = data.get('password')

    if not username or not password:
        return jsonify({'error': 'Username and password are required'}), 400

    hashed_password = hash_password(password)

    cursor.execute("SELECT * FROM users WHERE username = ? AND password_hash = ?", (username, hashed_password))
    user = cursor.fetchone()

    if user:
        return jsonify({'message': 'Login successful', 'wallet_address': user[3]}), 200
    else:
        return jsonify({'error': 'Invalid username or password'}), 401

if __name__ == '__main__':
    app.run(debug=True)