pragma solidity ^0.8.20;

contract AlternateRealityProtocol {
    address public admin;

    struct Reality {
        string basis;        // e.g. fee, delay, ambiguous message
        string constructed;  // e.g. crime narrative, collapse, law enforcement matter
        uint256 timestamp;
    }

    Reality[] public realities;

    event RealityLogged(string basis, string constructed, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logReality(string calldata basis, string calldata constructed) external onlyAdmin {
        realities.push(Reality(basis, constructed, block.timestamp));
        emit RealityLogged(basis, constructed, block.timestamp);
    }

    function totalRealities() external view returns (uint256) {
        return realities.length;
    }
}
