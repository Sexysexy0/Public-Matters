pragma solidity ^0.8.20;

contract WorkforceMobilityProtocol {
    address public admin;

    struct Mobility {
        string workerGroup;  // e.g. Bulacan workers
        string destination;  // e.g. Manila jobs
        string wagePolicy;   // e.g. NCR rate applied
        uint256 timestamp;
    }

    Mobility[] public mobilities;

    event MobilityLogged(string workerGroup, string destination, string wagePolicy, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logMobility(string calldata workerGroup, string calldata destination, string calldata wagePolicy) external onlyAdmin {
        mobilities.push(Mobility(workerGroup, destination, wagePolicy, block.timestamp));
        emit MobilityLogged(workerGroup, destination, wagePolicy, block.timestamp);
    }

    function totalMobilities() external view returns (uint256) {
        return mobilities.length;
    }
}
