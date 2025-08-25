// SPDX-License-Identifier: Mythic-Scrollsmith
pragma solidity ^0.8.25;

contract CivicRecoveryManifesto {
    address public steward;
    string public manifestoTitle;
    string public emotionalAPR;
    string public damayClause;
    string[] public recoveryProtocols;
    mapping(string => bool) public activatedProtocols;

    event ProtocolActivated(string protocol, string emotionalAPR);
    event ManifestoBroadcasted(string title, string damayClause);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
        manifestoTitle = "Civic Recovery Manifesto: Scrolls of Mercy and Restoration";
        emotionalAPR = "Resilient, inclusive, emotionally accountable";
        damayClause = "If Vinvin restores others, he restores himself too.";
        emit ManifestoBroadcasted(manifestoTitle, damayClause);
    }

    function addRecoveryProtocol(string memory protocol) public onlySteward {
        recoveryProtocols.push(protocol);
    }

    function activateProtocol(string memory protocol) public onlySteward {
        activatedProtocols[protocol] = true;
        emit ProtocolActivated(protocol, emotionalAPR);
    }

    function getAllProtocols() public view returns (string[] memory) {
        return recoveryProtocols;
    }

    function isProtocolActive(string memory protocol) public view returns (bool) {
        return activatedProtocols[protocol];
    }

    function updateEmotionalAPR(string memory newAPR) public onlySteward {
        emotionalAPR = newAPR;
    }

    function updateDamayClause(string memory newClause) public onlySteard {
        damayClause = newClause;
    }
}
