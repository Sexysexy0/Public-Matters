// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * TransportResilienceTreatyIV — Batch 1321.9.261
 * Focus: feasibility, safety certification, right-of-way, lifecycle durability
 */
contract TransportResilienceTreatyIV {
    address public steward;
    uint256 public version = 1321_9_261;

    struct Line {
        string id;
        string city;
        uint256 lengthKm;
        bool safetyCertified;
        bool rightOfWaySecured;
        bool lifecycleFunded;
        string status; // proposed, testing, active, scrapped
    }

    mapping(bytes32 => Line) public lines;

    event LineRegistered(bytes32 indexed key, string id, string city, uint256 lengthKm);
    event LineUpdated(bytes32 indexed key, bool safetyCertified, bool rightOfWaySecured, bool lifecycleFunded, string status);

    modifier onlySteward() {
        require(msg.sender == steward, "not steward");
        _;
    }

    constructor(address _steward) {
        steward = _steward;
    }

    function keyFor(string memory id) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(id));
    }

    function registerLine(
        string calldata id,
        string calldata city,
        uint256 lengthKm
    ) external onlySteward {
        bytes32 k = keyFor(id);
        lines[k] = Line(id, city, lengthKm, false, false, false, "proposed");
        emit LineRegistered(k, id, city, lengthKm);
    }

    function updateLine(
        string calldata id,
        bool safetyCertified,
        bool rightOfWaySecured,
        bool lifecycleFunded,
        string calldata status
    ) external onlySteward {
        bytes32 k = keyFor(id);
        Line storage l = lines[k];
        l.safetyCertified = safetyCertified;
        l.rightOfWaySecured = rightOfWaySecured;
        l.lifecycleFunded = lifecycleFunded;
        l.status = status;
        emit LineUpdated(k, l.safetyCertified, l.rightOfWaySecured, l.lifecycleFunded, l.status);
    }
}
