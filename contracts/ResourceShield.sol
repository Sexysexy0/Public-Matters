// contracts/ResourceShield.sol
pragma solidity ^0.8.20;

contract ResourceShield {
    address public admin;

    struct Resource {
        string type;        // "Oil", "Gas", "Fishery"
        string protection;
        uint256 timestamp;
    }

    Resource[] public resources;

    event ResourceLogged(string type, string protection, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }
    constructor() { admin = msg.sender; }

    function logResource(string calldata type, string calldata protection) external onlyAdmin {
        resources.push(Resource(type, protection, block.timestamp));
        emit ResourceLogged(type, protection, block.timestamp);
    }
}
