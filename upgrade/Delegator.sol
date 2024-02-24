// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

contract Delegator {
    address public delegate;

    event DelegateSet(address indexed oldDelegate, address indexed newDelegate);

    constructor(address _delegate) {
        delegate = _delegate;
        emit DelegateSet(address(0), _delegate);
    }

    function setDelegate(address _newDelegate) external {
        require(_newDelegate != address(0), "Invalid delegate address");
        require(msg.sender == delegate, "Only current delegate can set new delegate");

        address oldDelegate = delegate;
        delegate = _newDelegate;

        emit DelegateSet(oldDelegate, _newDelegate);
    }

    function executeDelegatedTransaction(address _to, bytes calldata _data) external returns (bytes memory result) {
        require(msg.sender == delegate, "Only delegate can execute delegated transactions");

        (bool success, bytes memory data) = _to.call(_data);
        require(success, "Delegate call failed");
        
        return data;
    }
}
