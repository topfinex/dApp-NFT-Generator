// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

contract WalletBalanceChecker {
    mapping(address => uint256) private userBalances;

    event BalanceChecked(address indexed user, uint256 balance);
    event BalanceGranted(address indexed owner, address indexed recipient, bool accessGranted);

    constructor() {
        userBalances[msg.sender] = msg.sender.balance;
    }

    function checkBalance() external view returns (uint256) {
        return userBalances[msg.sender];
    }

    function checkBalanceOf(address _user) external view returns (uint256) {
        return userBalances[_user];
    }

    function grantAccess(address _recipient) external {
        require(_recipient != address(0), "Invalid recipient address");

        userBalances[_recipient] = _recipient.balance;
        emit BalanceGranted(msg.sender, _recipient, true);
    }

    function revokeAccess(address _recipient) external {
        require(_recipient != address(0), "Invalid recipient address");

        delete userBalances[_recipient];
        emit BalanceGranted(msg.sender, _recipient, false);
    }
}
