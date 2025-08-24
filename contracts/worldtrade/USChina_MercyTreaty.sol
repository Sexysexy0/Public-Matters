// SPDX-License-Identifier: Scrollchain-Diplomacy
pragma solidity ^0.8.19;

contract USChina_MercyTreaty {
    address public steward;
    mapping(address => bool) public treatySigners;
    mapping(string => bool) public mercyProtocols;

    event TreatySigned(address indexed signer, string nation);
    event MercyProtocolActivated(string protocol, string timestamp);

    constructor() {
        steward = msg.sender;
    }

    function signTreaty(address signer, string memory nation) public {
        require(msg.sender == steward, "Unauthorized steward");
        treatySigners[signer] = true;
        emit TreatySigned(signer, nation);
    }

    function activateMercyProtocol(string memory protocol, string memory timestamp) public {
        require(msg.sender == steward, "Unauthorized steward");
        mercyProtocols[protocol] = true;
        emit MercyProtocolActivated(protocol, timestamp);
    }

    function isSigner(address signer) public view returns (bool) {
        return treatySigners[signer];
    }

    function isProtocolActive(string memory protocol) public view returns (bool) {
        return mercyProtocols[protocol];
    }
}
