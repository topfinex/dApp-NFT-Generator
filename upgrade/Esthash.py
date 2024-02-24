from web3 import Web3
from web3.middleware import geth_poa_middleware
import os

# Infura endpoint
infura_url = os.environ.get('INFURA_URL')  # Update with your Infura URL

# Ethereum account private key
private_key = os.environ.get('PRIVATE_KEY')  # Update with your Ethereum account private key

# Ethereum addresses
sender_address = os.environ.get('SENDER_ADDRESS')  # Update with your sender address
recipient_address = os.environ.get('RECIPIENT_ADDRESS')  # Update with your recipient address

# Connect to Ethereum node
w3 = Web3(Web3.HTTPProvider(infura_url))
w3.middleware_onion.inject(geth_poa_middleware, layer=0)

# Check connection
if w3.isConnected():
    print("Connected to Ethereum node")
else:
    print("Failed to connect to Ethereum node")

# Get balance of sender address
balance = w3.eth.get_balance(sender_address)
print("Sender address balance:", w3.fromWei(balance, 'ether'), "ETH")

# Build transaction
transaction = {
    'to': recipient_address,
    'value': w3.toWei(0.1, 'ether'),  # Amount to send in wei (0.1 ETH)
    'gas': 2000000,
    'gasPrice': w3.toWei('50', 'gwei'),  # Gas price in gwei (50 Gwei)
    'nonce': w3.eth.getTransactionCount(sender_address),
}

# Sign transaction
signed_txn = w3.eth.account.signTransaction(transaction, private_key)

# Send transaction
tx_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)
print("Transaction sent:", tx_hash.hex())

# Wait for transaction receipt
receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
print("Transaction receipt received:", receipt)
