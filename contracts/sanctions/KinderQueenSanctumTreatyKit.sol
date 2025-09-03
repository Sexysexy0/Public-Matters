// KinderQueenSanctumTreatyKit.sol
pragma solidity ^0.8.19;

contract KinderQueenSanctumTreatyKit {
    address public steward;
    mapping(string => bool) public approvedJurisdictions;
    mapping(string => bool) public blessingBlocked;

    event BlessingRedirected(string jurisdiction);
    event BlessingBlocked(string jurisdiction);

    constructor() {
        steward = msg.sender;
        approvedJurisdictions["United States"] = true;
        approvedJurisdictions["Philippines"] = true;
    }

    function blockBlessing(string memory jurisdiction) public {
        require(msg.sender == steward, "Only steward may block");
        blessingBlocked[jurisdiction] = true;
        emit BlessingBlocked(jurisdiction);
    }

    function redirectBlessing(string memory jurisdiction) public {
        require(msg.sender == steward, "Only steward may redirect");
        blessingBlocked[jurisdiction] = true;
        emit BlessingRedirected(jurisdiction);
    }

    function isBlessed(string memory jurisdiction) public view returns (bool) {
        return approvedJurisdictions[jurisdiction] && !blessingBlocked[jurisdiction];
    }
}
