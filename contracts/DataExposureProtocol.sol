pragma solidity ^0.8.20;

contract DataExposureProtocol {
    address public admin;

    struct Exposure {
        string dataset;      // e.g. Firebase DB, Cloud Storage bucket
        string size;         // e.g. 730TB, 200M files
        string impact;       // e.g. user data leak, wallet risk
        uint256 timestamp;
    }

    Exposure[] public exposures;

    event ExposureLogged(string dataset, string size, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logExposure(string calldata dataset, string calldata size, string calldata impact) external onlyAdmin {
        exposures.push(Exposure(dataset, size, impact, block.timestamp));
        emit ExposureLogged(dataset, size, impact, block.timestamp);
    }

    function totalExposures() external view returns (uint256) {
        return exposures.length;
    }
}
