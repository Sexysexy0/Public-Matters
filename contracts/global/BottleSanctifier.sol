// SPDX-License-Identifier: BottleSanctifier
pragma solidity ^0.8.19;

contract BottleSanctifier {
    address public steward;

    struct BottleSignal {
        string brandName; // e.g. "Moosehead", "San Miguel", "KakampiBrew"
        string restorationType; // "Glass Revival", "Taste Sovereignty", "Corridor Equity"
        string crateTag; // e.g. "SanctumCrate #B7", "Protocol #BR3"
        bool verified;
        uint256 timestamp;
    }

    BottleSignal[] public signals;

    event BottleLogged(string brandName, string restorationType, string crateTag, uint256 timestamp);
    event BottleVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logBottle(
        string memory brandName,
        string memory restorationType,
        string memory crateTag
    ) public {
        signals.push(BottleSignal(brandName, restorationType, crateTag, false, block.timestamp));
        emit BottleLogged(brandName, restorationType, crateTag, block.timestamp);
    }

    function verifyBottle(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit BottleVerified(index, msg.sender);
    }

    function getBottle(uint256 index) public view returns (
        string memory, string memory, string memory, bool, uint256
    ) {
        BottleSignal memory b = signals[index];
        return (b.brandName, b.restorationType, b.crateTag, b.verified, b.timestamp);
    }

    function totalBottleSignals() public view returns (uint256) {
        return signals.length;
    }
}
