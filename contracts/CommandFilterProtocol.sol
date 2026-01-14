pragma solidity ^0.8.20;

contract CommandFilterProtocol {
    address public admin;

    struct Filter {
        string command;      // e.g. "put in bikini"
        bool allowed;        // true if safe, false if blocked
        uint256 timestamp;
    }

    Filter[] public filters;

    event FilterLogged(string command, bool allowed, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logFilter(string calldata command, bool allowed) external onlyAdmin {
        filters.push(Filter(command, allowed, block.timestamp));
        emit FilterLogged(command, allowed, block.timestamp);
    }

    function totalFilters() external view returns (uint256) {
        return filters.length;
    }
}
