// TreatyBalanceProtocol.sol
pragma solidity ^0.8.0;

contract TreatyBalanceProtocol {
    struct Demand {
        uint256 id;
        string clause;       // e.g. "Lift sanctions"
        string status;       // e.g. "Granted"
        uint256 timestamp;
    }

    uint256 public demandCount;
    mapping(uint256 => Demand) public demands;

    event DemandGranted(uint256 id, string clause, string status);

    function grantDemand(string memory clause, string memory status) public {
        demandCount++;
        demands[demandCount] = Demand(demandCount, clause, status, block.timestamp);
        emit DemandGranted(demandCount, clause, status);
    }
}
