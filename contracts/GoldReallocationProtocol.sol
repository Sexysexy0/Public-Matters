pragma solidity ^0.8.20;

contract GoldReallocationProtocol {
    address public admin;

    struct Reallocation {
        string asset;        // e.g. physical gold, mining stocks
        uint256 percentage;  // portfolio allocation
        uint256 timestamp;
    }

    Reallocation[] public reallocations;

    event ReallocationLogged(string asset, uint256 percentage, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logReallocation(string calldata asset, uint256 percentage) external onlyAdmin {
        reallocations.push(Reallocation(asset, percentage, block.timestamp));
        emit ReallocationLogged(asset, percentage, block.timestamp);
    }

    function totalReallocations() external view returns (uint256) {
        return reallocations.length;
    }
}
