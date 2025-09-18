// SPDX-License-Identifier: GrowerSanctum
pragma solidity ^0.8.19;

contract LegacyGrowerRouter {
    address public steward;

    struct GrowerSignal {
        string growerID;
        string region;
        string licenseStatus; // "Pending", "Approved", "Denied"
        string dispensaryTag; // e.g. "North Luzon #3", "Metro Manila #5"
        bool verified;
        uint256 timestamp;
    }

    GrowerSignal[] public signals;

    event GrowerLogged(string growerID, string region, string licenseStatus, string dispensaryTag, uint256 timestamp);
    event GrowerVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logGrower(
        string memory growerID,
        string memory region,
        string memory licenseStatus,
        string memory dispensaryTag
    ) public {
        signals.push(GrowerSignal(growerID, region, licenseStatus, dispensaryTag, false, block.timestamp));
        emit GrowerLogged(growerID, region, licenseStatus, dispensaryTag, block.timestamp);
    }

    function verifyGrower(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit GrowerVerified(index, msg.sender);
    }

    function getGrower(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, bool, uint256
    ) {
        GrowerSignal memory g = signals[index];
        return (g.growerID, g.region, g.licenseStatus, g.dispensaryTag, g.verified, g.timestamp);
    }

    function totalGrowerSignals() public view returns (uint256) {
        return signals.length;
    }
}
