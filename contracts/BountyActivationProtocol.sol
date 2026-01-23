pragma solidity ^0.8.20;

contract BountyActivationProtocol {
    address public admin;

    struct Bounty {
        string device;       // e.g. Nest thermostat
        uint256 amount;      // e.g. 14000
        string status;       // e.g. active, claimed
        uint256 timestamp;
    }

    Bounty[] public bounties;

    event BountyLogged(string device, uint256 amount, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logBounty(string calldata device, uint256 amount, string calldata status) external onlyAdmin {
        bounties.push(Bounty(device, amount, status, block.timestamp));
        emit BountyLogged(device, amount, status, block.timestamp);
    }

    function totalBounties() external view returns (uint256) {
        return bounties.length;
    }
}
