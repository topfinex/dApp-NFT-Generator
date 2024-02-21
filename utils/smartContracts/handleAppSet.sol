// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

contract MyToken {
    mapping(address => mapping(address => uint256)) public allowance;

    event Approval(address indexed owner, address indexed spender, uint256 value);

    function approve(address spender, uint256 /* currentValue */, uint256 value) external returns (bool success) {
        require(spender != address(0), "Invalid spender address");
        
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
}
