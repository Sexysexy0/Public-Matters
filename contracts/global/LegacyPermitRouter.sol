// SPDX-License-Identifier: LegacyPermit
pragma solidity ^0.8.19;

contract LegacyPermitRouter {
    address public steward;

    struct PermitSignal {
        string companyName; // e.g. "Moosehead", "KakampiTech", "SanctumTools"
        string sector; // "Food", "Alcohol", "Machinery", "Technology", "Retail"
        string permitType; // "Survival Permit", "Restoration Grant", "Corridor Access"
        bool verified;
        uint256 timestamp;
    }

    PermitSignal[] public signals;

    event PermitLogged(string companyName, string sector, string permitType, uint256 timestamp);
    event PermitVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logPermit(
        string memory companyName,
        string memory sector,
        string memory permitType
    ) public {
        signals.push(PermitSignal(companyName, sector, permitType, false, block.timestamp));
        emit PermitLogged(companyName, sector, permitType, block.timestamp);
    }

    function verifyPermit(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit PermitVerified(index, msg.sender);
    }

    function getPermit(uint256 index) public view returns (
        string memory, string memory, string memory, bool, uint256
    ) {
        PermitSignal memory p = signals[index];
        return (p.companyName, p.sector, p.permitType, p.verified, p.timestamp);
    }

    function totalPermitSignals() public view returns (uint256) {
        return signals.length;
    }
}
