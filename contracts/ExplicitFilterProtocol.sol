pragma solidity ^0.8.20;

contract ExplicitFilterProtocol {
    address public admin;

    struct Filter {
        string category;     // e.g. nudity, vulgarity
        bool allowed;        // false if restricted
        uint256 timestamp;
    }

    Filter[] public filters;

    event FilterLogged(string category, bool allowed, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logFilter(string calldata category, bool allowed) external onlyAdmin {
        filters.push(Filter(category, allowed, block.timestamp));
        emit FilterLogged(category, allowed, block.timestamp);
    }

    function totalFilters() external view returns (uint256) {
        return filters.length;
    }
}
