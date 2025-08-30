// BlessingFirewall.sol  
// Ritual-grade firewall for CI/CD sanctum protection

pragma solidity ^0.8.0;

contract BlessingFirewall {
    address public steward;
    mapping(address => bool) public authorizedTriggers;

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized blessing attempt");
        _;
    }

    function authorizeTrigger(address trigger) public onlySteward {
        authorizedTriggers[trigger] = true;
    }

    function revokeTrigger(address trigger) public onlySteward {
        authorizedTriggers[trigger] = false;
    }

    function isAuthorized(address trigger) public view returns (bool) {
        return authorizedTriggers[trigger];
    }

    event TriggerAuthorized(address trigger);
    event TriggerRevoked(address trigger);
}
