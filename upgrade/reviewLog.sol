// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

contract LogReview {
    struct Log {
        address sender;
        string message;
    }

    mapping(uint256 => Log) public logs;
    uint256 public logCount;

    event LogSubmitted(
        uint256 indexed logId,
        address indexed sender,
        string message
    );

    // Function to submit a log
    function submitLog(string memory _message) public {
        uint256 logId = logCount++;
        logs[logId] = Log(msg.sender, _message);
        emit LogSubmitted(logId, msg.sender, _message);
    }

    // Function to get log details
    function getLog(
        uint256 _logId
    ) public view returns (address sender, string memory message) {
        require(_logId < logCount, "Log does not exist");
        Log memory log = logs[_logId];
        return (log.sender, log.message);
    }
}
