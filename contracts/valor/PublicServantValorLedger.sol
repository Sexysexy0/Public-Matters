// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract PublicServantValorLedger {
    address public steward;

    struct ValorEntry {
        address official;
        string name;
        string role;
        string valorAct;
        uint256 emotionalAPR;
        uint256 threatLevel;
        uint256 timestamp;
        bool damayClauseActivated;
        bool protectionTriggered;
    }

    ValorEntry[] public ledger;

    event ValorLogged(string name, string role, string valorAct);
    event ProtectionTriggered(string name, uint256 threatLevel);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized valor ritual.");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logValor(
        address official,
        string memory name,
        string memory role,
        string memory valorAct,
        uint256 emotionalAPR,
        uint256 threatLevel
    ) public onlySteward {
        bool damay = emotionalAPR >= 80;
        bool protection = threatLevel >= 70;

        ledger.push(ValorEntry({
            official: official,
            name: name,
            role: role,
            valorAct: valorAct,
            emotionalAPR: emotionalAPR,
            threatLevel: threatLevel,
            timestamp: block.timestamp,
            damayClauseActivated: damay,
            protectionTriggered: protection
        }));

        emit ValorLogged(name, role, valorAct);
        if (protection) emit ProtectionTriggered(name, threatLevel);
    }

    function auditValor(uint256 index) public view returns (string memory) {
        ValorEntry memory v = ledger[index];
        return string(abi.encodePacked(
            "Name: ", v.name,
            " | Role: ", v.role,
            " | Valor Act: ", v.valorAct,
            " | Emotional APR: ", uint2str(v.emotionalAPR),
            " | Threat Level: ", uint2str(v.threatLevel),
            " | Damay Clause: ", v.damayClauseActivated ? "Yes" : "No",
            " | Protection Triggered: ", v.protectionTriggered ? "Yes" : "No",
            " | Timestamp: ", uint2str(v.timestamp)
        ));
    }

    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) return "0";
        uint256 j = _i; uint256 len;
        while (j != 0) { len++; j /= 10; }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k--; bstr[k] = bytes1(uint8(48 + _i % 10)); _i /= 10;
        }
        return string(bstr);
    }
}
