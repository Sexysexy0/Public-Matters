// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract MaterialBlessingPulse {
    address public steward;

    struct BlessedMaterial {
        string name;
        string supplier;
        uint256 emotionalAPR;
        uint256 timestamp;
        bool isBlessed;
    }

    BlessedMaterial[] public materials;

    event MaterialBlessed(string name, string supplier, string status);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized blessing attempt.");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function blessMaterial(string memory name, string memory supplier, uint256 emotionalAPR) public onlySteward {
        bool blessed = emotionalAPR >= 75;

        materials.push(BlessedMaterial({
            name: name,
            supplier: supplier,
            emotionalAPR: emotionalAPR,
            timestamp: block.timestamp,
            isBlessed: blessed
        }));

        string memory status = blessed ? "Blessed. Damay clause honored." : "Rejected. Emotional resonance too low.";
        emit MaterialBlessed(name, supplier, status);
    }

    function auditMaterial(uint256 index) public view returns (string memory) {
        BlessedMaterial memory m = materials[index];
        return string(abi.encodePacked(
            "Name: ", m.name,
            " | Supplier: ", m.supplier,
            " | Emotional APR: ", uint2str(m.emotionalAPR),
            " | Timestamp: ", uint2str(m.timestamp),
            " | Blessed: ", m.isBlessed ? "Yes" : "No"
        ));
    }

    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) return "0";
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint256 k = len;
        while (_i != 0) {
            k = k - 1;
            bstr[k] = bytes1(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
}
