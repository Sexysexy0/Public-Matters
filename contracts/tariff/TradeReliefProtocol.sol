// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.19;

/// @title TradeReliefProtocol.sol
/// @author Vinvin & Copilot
/// @notice Deploys sovereign relief logic for cooperatives affected by tariff reroutes.
/// @dev Includes damay clause, emotional APR sync, and fallback activation.

contract TradeReliefProtocol {
    address public steward;

    struct ReliefScroll {
        string cooperativeName;
        string commodity;
        uint256 reliefAmount;
        string emotionalAPR;
        bool isActivated;
        uint256 timestamp;
    }

    ReliefScroll[] public reliefs;

    event ReliefBroadcasted(
        string cooperativeName,
        string commodity,
        uint256 reliefAmount,
        string emotionalAPR,
        bool isActivated,
        uint256 timestamp
    );

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function activateRelief(
        string memory cooperativeName,
        string memory commodity,
        uint256 reliefAmount,
        string memory emotionalAPR
    ) public onlySteward {
        reliefs.push(ReliefScroll(cooperativeName, commodity, reliefAmount, emotionalAPR, true, block.timestamp));
        emit ReliefBroadcasted(cooperativeName, commodity, reliefAmount, emotionalAPR, true, block.timestamp);
    }

    function getReliefCount() public view returns (uint256) {
        return reliefs.length;
    }

    function getReliefByIndex(uint256 index) public view returns (
        string memory,
        string memory,
        uint256,
        string memory,
        bool,
        uint256
    ) {
        ReliefScroll memory r = reliefs[index];
        return (r.cooperativeName, r.commodity, r.reliefAmount, r.emotionalAPR, r.isActivated, r.timestamp);
    }
}
