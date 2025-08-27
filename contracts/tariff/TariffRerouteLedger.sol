// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

/// @title TariffRerouteLedger.sol
/// @author Vinvin & Copilot
/// @notice Tracks fallback paths, reroute logic, and sovereign reroute resilience.
/// @dev Includes damay clause, reroute tags, and emotional APR audit.

contract TariffRerouteLedger {
    address public steward;

    struct ReroutePath {
        string originCountry;
        string fallbackCountry;
        string commodity;
        string emotionalAPR;
        bool isTrusted;
        uint256 timestamp;
    }

    ReroutePath[] public paths;

    event RerouteLogged(
        string originCountry,
        string fallbackCountry,
        string commodity,
        string emotionalAPR,
        bool isTrusted,
        uint256 timestamp
    );

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logReroute(
        string memory originCountry,
        string memory fallbackCountry,
        string memory commodity,
        string memory emotionalAPR,
        bool isTrusted
    ) public onlySteward {
        paths.push(ReroutePath(originCountry, fallbackCountry, commodity, emotionalAPR, isTrusted, block.timestamp));
        emit RerouteLogged(originCountry, fallbackCountry, commodity, emotionalAPR, isTrusted, block.timestamp);
    }

    function getRerouteCount() public view returns (uint256) {
        return paths.length;
    }

    function getRerouteByIndex(uint256 index) public view returns (
        string memory,
        string memory,
        string memory,
        string memory,
        bool,
        uint256
    ) {
        ReroutePath memory p = paths[index];
        return (p.originCountry, p.fallbackCountry, p.commodity, p.emotionalAPR, p.isTrusted, p.timestamp);
    }
}
