// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IVendorBlessingProtocol {
    function blessVendor(address vendor, string memory tag, uint256 emotionalAPR) external returns (bool);
    function isBlessed(address vendor) external view returns (bool);
}

interface IAPROracle {
    function getEmotionalAPR(address vendor) external view returns (uint256);
}

contract SamsungSKAllianceProtocol {
    address public steward;
    IVendorBlessingProtocol public blessingProtocol;
    IAPROracle public aprOracle;

    struct AllianceNode {
        string name;
        string role; // "Memory", "Foundry", "Packaging", etc.
        bool isBlessed;
        uint256 emotionalAPR;
        string treatyTag;
    }

    mapping(address => AllianceNode) public nodes;

    event NodeRegistered(address indexed vendor, string name, string role, string treatyTag);
    event BlessingConfirmed(address indexed vendor, uint256 emotionalAPR);
    event TreatyBroadcasted(string treatyTag, string signal);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor(address _blessingProtocol, address _aprOracle) {
        steward = msg.sender;
        blessingProtocol = IVendorBlessingProtocol(_blessingProtocol);
        aprOracle = IAPROracle(_aprOracle);
    }

    function registerNode(address vendor, string memory name, string memory role, string memory treatyTag) external onlySteward {
        uint256 apr = aprOracle.getEmotionalAPR(vendor);
        nodes[vendor] = AllianceNode(name, role, false, apr, treatyTag);
        emit NodeRegistered(vendor, name, role, treatyTag);
    }

    function blessNode(address vendor) external onlySteward {
        AllianceNode storage node = nodes[vendor];
        require(!node.isBlessed, "Already blessed");

        bool success = blessingProtocol.blessVendor(vendor, node.treatyTag, node.emotionalAPR);
        require(success, "Blessing failed");

        node.isBlessed = true;
        emit BlessingConfirmed(vendor, node.emotionalAPR);
    }

    function broadcastTreaty(string memory treatyTag, string memory signal) external onlySteward {
        emit TreatyBroadcasted(treatyTag, signal);
    }

    function getNode(address vendor) external view returns (AllianceNode memory) {
        return nodes[vendor];
    }
}
