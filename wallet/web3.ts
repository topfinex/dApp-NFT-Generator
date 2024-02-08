// Copyright [2024] [Topfinex]
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
// http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

const Web3 = require('web3');

const infuraUrl = `https://mainnet.infura.io/v3/${process.env.GITHUB_AUTH_TOKEN}`;

const web3 = new Web3(infuraUrl);

// Ethereum address of the smart contract
const contractAddress = '0x21e6fc92f93c8a1bb41e2be64b4e1f88a54d3576';

const contractABI = [];

const contract = new web3.eth.Contract(contractABI, contractAddress);

function checkUserBalance() {
    contract.methods.checkBalance().call((error, result) => {
        if (!error) {
            console.log('User balance:', result);
        } else {
            console.error('Error:', error);
        }
    });
}

checkUserBalance();
