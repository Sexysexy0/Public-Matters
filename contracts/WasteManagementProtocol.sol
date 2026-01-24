pragma solidity ^0.8.20;

contract WasteManagementProtocol {
    address public admin;

    struct Waste {
        string method;       // e.g. dry cask storage, recycling
        string status;       // e.g. planned, ongoing, completed
        string location;     // e.g. BNPP site, offsite facility
        uint256 timestamp;
    }

    Waste[] public wastes;

    event WasteLogged(string method, string status, string location, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logWaste(string calldata method, string calldata status, string calldata location) external onlyAdmin {
        wastes.push(Waste(method, status, location, block.timestamp));
        emit WasteLogged(method, status, location, block.timestamp);
    }

    function totalWastes() external view returns (uint256) {
        return wastes.length;
    }
}
