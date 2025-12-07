// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * TransparencyDisclosureLedgerIV — Batch 1321.9.261
 * Seal: Publish conflict-of-interest disclosures and decision logs
 */
contract TransparencyDisclosureLedgerIV {
    address public steward;
    uint256 public version = 1321_9_261;

    struct Disclosure {
        string officialId;
        string interests;      // summary of business ties, relatives, holdings
        string decisionLogUri; // link/IPFS to decisions and rationale
        uint256 timestamp;
    }

    mapping(bytes32 => Disclosure[]) public records;

    event DisclosureLogged(bytes32 indexed key, string officialId, string interests, string decisionLogUri);

    modifier onlySteward() {
        require(msg.sender == steward, "not steward");
        _;
    }

    constructor(address _steward) {
        steward = _steward;
    }

    function keyFor(string memory officialId) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(officialId));
    }

    function logDisclosure(
        string calldata officialId,
        string calldata interests,
        string calldata decisionLogUri
    ) external onlySteward {
        bytes32 k = keyFor(officialId);
        records[k].push(Disclosure(officialId, interests, decisionLogUri, block.timestamp));
        emit DisclosureLogged(k, officialId, interests, decisionLogUri);
    }

    function count(string calldata officialId) external view returns (uint256) {
        return records[keyFor(officialId)].length;
    }
}
