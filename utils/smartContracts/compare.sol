// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract CustomToken is ERC20, Ownable, Pausable {
    using Address for address;
    uint8 decimals;

    mapping(address => bool) public blacklist;
    mapping(address => bool) public whitelist;

    event BlacklistUpdated(address indexed account, bool isBlacklisted);
    event WhitelistUpdated(address indexed account, bool isWhitelisted);

    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        uint256 initialSupply_
    ) ERC20(name_, symbol_) {
         _setupDecimals(decimals_);
        _mint(msg.sender, initialSupply_);
    }

    modifier validAddress(address _addr) {
        require(_addr != address(0), "Invalid address");
        _;
    }

    function _setupDecimals(uint8 _decimals) internal {
        decimals = _decimals;
    }

    function transfer(
        address to,
        uint256 amount
    ) public override whenNotPaused validAddress(to) returns (bool) {
        require(!blacklist[msg.sender], "Sender is blacklisted");
        require(!blacklist[to], "Recipient is blacklisted");
        require(
            whitelist[msg.sender] || whitelist[to],
            "Either sender or recipient must be whitelisted"
        );
        return super.transfer(to, amount);
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override whenNotPaused validAddress(to) returns (bool) {
        require(!blacklist[from], "Sender is blacklisted");
        require(!blacklist[to], "Recipient is blacklisted");
        require(
            whitelist[from] || whitelist[to],
            "Either sender or recipient must be whitelisted"
        );
        return super.transferFrom(from, to, amount);
    }

    function updateBlacklist(
        address account,
        bool isBlacklisted
    ) external onlyOwner validAddress(account) {
        blacklist[account] = isBlacklisted;
        emit BlacklistUpdated(account, isBlacklisted);
    }

    function updateWhitelist(
        address account,
        bool isWhitelisted
    ) external onlyOwner validAddress(account) {
        whitelist[account] = isWhitelisted;
        emit WhitelistUpdated(account, isWhitelisted);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override whenNotPaused {
        super._beforeTokenTransfer(from, to, amount);
        require(!blacklist[from], "Sender is blacklisted");
        require(!blacklist[to], "Recipient is blacklisted");
        require(
            whitelist[from] || whitelist[to],
            "Either sender or recipient must be whitelisted"
        );
    }
}