import hashlib
import json
from datetime import datetime
import requests
from flask import Flask, request, jsonify

class Transaction:
    def __init__(self, sender, recipient, amount):
        self.sender = sender
        self.recipient = recipient
        self.amount = amount
        self.timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    def to_dict(self):
        return {
            'sender': self.sender,
            'recipient': self.recipient,
            'amount': self.amount,
            'timestamp': self.timestamp
        }

    def hash_transaction(self):
        transaction_string = json.dumps(self.to_dict(), sort_keys=True).encode()
        return hashlib.sha256(transaction_string).hexdigest()

class Block:
    def __init__(self, transactions, previous_hash):
        self.transactions = transactions
        self.previous_hash = previous_hash
        self.timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        self.nonce = 0
        self.hash = self.calculate_hash()

    def calculate_hash(self):
        block_string = json.dumps({
            'transactions': [tx.hash_transaction() for tx in self.transactions],
            'previous_hash': self.previous_hash,
            'timestamp': self.timestamp,
            'nonce': self.nonce
        }, sort_keys=True).encode()
        return hashlib.sha256(block_string).hexdigest()

    def mine_block(self, difficulty):
        while self.hash[:difficulty] != '0' * difficulty:
            self.nonce += 1
            self.hash = self.calculate_hash()

    def is_valid(self):
        for i in range(1, len(self.transactions)):
            if self.transactions[i].hash_transaction() != self.transactions[i].hash_transaction():
                return False
        return True

class Blockchain:
    def __init__(self):
        self.chain = [self.create_genesis_block()]
        self.pending_transactions = []
        self.difficulty = 2  # Number of leading zeros required in the block hash

    def create_genesis_block(self):
        return Block([Transaction('', '', 0)], '0')

    def get_last_block(self):
        return self.chain[-1]

    def add_transaction(self, transaction):
        self.pending_transactions.append(transaction)

    def mine_pending_transactions(self, miner_address):
        block = Block(self.pending_transactions, self.get_last_block().hash)
        block.mine_block(self.difficulty)
        self.chain.append(block)
        self.pending_transactions = [Transaction('', miner_address, 10)]  # Rewarding the miner

    def is_chain_valid(self):
        for i in range(1, len(self.chain)):
            current_block = self.chain[i]
            previous_block = self.chain[i - 1]

            if current_block.hash != current_block.calculate_hash():
                return False
            if current_block.previous_hash != previous_block.hash:
                return False
            if not current_block.is_valid():
                return False

        return True

app = Flask(__name__)
blockchain = Blockchain()

@app.route('/transactions/new', methods=['POST'])
def new_transaction():
    data = request.get_json()
    required_fields = ['sender', 'recipient', 'amount']
    if not all(field in data for field in required_fields):
        return 'Missing values', 400

    transaction = Transaction(data['sender'], data['recipient'], data['amount'])
    blockchain.add_transaction(transaction)

    response = {'message': f'Transaction will be added to Block {len(blockchain.chain)}'}
    return jsonify(response), 201

@app.route('/mine', methods=['GET'])
def mine():
    blockchain.mine_pending_transactions("miner_address")
    response = {'message': 'Congratulations, you just mined a block!',
                'block': blockchain.chain[-1].__dict__}
    return jsonify(response), 200

@app.route('/chain', methods=['GET'])
def full_chain():
    response = {
        'chain': [block.__dict__ for block in blockchain.chain],
        'length': len(blockchain.chain)
    }
    return jsonify(response), 200

if __name__ == '__main__':
    from argparse import ArgumentParser
    parser = ArgumentParser()
    parser.add_argument('-p', '--port', default=5000, type=int, help='port to listen on')
    args = parser.parse_args()
    port = args.port
    app.run(host='0.0.0.0', port=port)
