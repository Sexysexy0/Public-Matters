// SPDX-License-Identifier: CovenantSanctum
pragma solidity ^0.8.19;

contract UnionSanctifier {
    address public steward;

    struct UnionSignal {
        string nationA; // e.g. "USA"
        string nationB; // e.g. "South Korea"
        string covenantAction; // e.g. "Apology", "Visa Reform", "Investment Guarantee"
        string blessingTag; // e.g. "Post-Raid Recovery", "Alliance Renewal"
        bool verified;
        uint256 timestamp;
    }

    UnionSignal[] public signals;

    event UnionLogged(string nationA, string nationB, string covenantAction, string blessingTag, uint256 timestamp);
    event UnionVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logUnion(
        string memory nationA,
        string memory nationB,
        string memory covenantAction,
        string memory blessingTag
    ) public {
        signals.push(UnionSignal(nationA, nationB, covenantAction, blessingTag, false, block.timestamp));
        emit UnionLogged(nationA, nationB, covenantAction, blessingTag, block.timestamp);
    }

    function verifyUnion(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit UnionVerified(index, msg.sender);
    }

    function getUnion(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, bool, uint256
    ) {
        UnionSignal memory u = signals[index];
        return (u.nationA, u.nationB, u.covenantAction, u.blessingTag, u.verified, u.timestamp);
    }

    function totalUnionSignals() public view returns (uint256) {
        return signals.length;
    }
}
