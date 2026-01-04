pragma solidity ^0.8.20;

contract ExposureMapProtocol {
    address public admin;
    struct Exposure { string asset; string vector; string severity; uint256 timestamp; }
    Exposure[] public exposures;
    event ExposureLogged(string asset, string vector, string severity, uint256 timestamp);
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }
    constructor() { admin = msg.sender; }
    function logExposure(string calldata asset, string calldata vector, string calldata severity) external onlyAdmin {
        exposures.push(Exposure(asset, vector, severity, block.timestamp));
        emit ExposureLogged(asset, vector, severity, block.timestamp);
    }
}
