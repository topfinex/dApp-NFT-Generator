// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

contract BloomFilter {
    uint256 constant private MAX_ELEMENTS = 1000;
    uint256 constant private FILTER_SIZE = 2048;
    uint256 private filter;

    event ElementAdded(bytes32 indexed element);

    constructor() {
        require(FILTER_SIZE % 256 == 0, "Filter size must be divisible by 256");
    }

    function addElement(bytes32 element) external {
        require(getElementIndex(element) == false, "Element already exists in the filter");
        require(getFilterPopulation() < MAX_ELEMENTS, "Filter is at maximum capacity");

        filter |= (1 << (uint256(element) % FILTER_SIZE));
        emit ElementAdded(element);
    }

    function getElementIndex(bytes32 element) public view returns (bool) {
        return (filter & (1 << (uint256(element) % FILTER_SIZE))) > 0;
    }

    function getFilterPopulation() public view returns (uint256) {
        uint256 population;
        uint256 f = filter;
        for (uint256 i = 0; i < FILTER_SIZE; i++) {
            population += (f & 1);
            f >>= 1;
        }
        return population;
    }
}
