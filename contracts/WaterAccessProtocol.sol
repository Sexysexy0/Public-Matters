pragma solidity ^0.8.20;

contract WaterAccessProtocol {
    address public admin;

    struct Supply {
        string community;    // e.g. rural village, urban district
        string status;       // e.g. clean, contaminated, rationed
        uint256 timestamp;
    }

    Supply[] public supplies;

    event SupplyLogged(string community, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logSupply(string calldata community, string calldata status) external onlyAdmin {
        supplies.push(Supply(community, status, block.timestamp));
        emit SupplyLogged(community, status, block.timestamp);
    }

    function totalSupplies() external view returns (uint256) {
        return supplies.length;
    }
}
