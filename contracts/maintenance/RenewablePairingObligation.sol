// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title RenewablePairingObligation
 * @notice Requires each registered data center to match a % of its energy use
 *         with owned/contracted renewable generation, or pay penalties.
 */
contract RenewablePairingObligation {
    address public steward;
    address public regulator;
    uint8 public minPairingPercent; // e.g., 50 means 50%

    struct DC {
        string name;
        address operator;
        bool registered;
        uint256 pairedMWh;
        uint256 consumedMWh;
    }
    mapping(address => DC) public dataCenters;
    mapping(address => uint256) public penaltiesDue;

    event Registered(address dc, address operator, string name);
    event UsageReported(address dc, uint256 consumedMWh, uint256 pairedMWh);
    event PenaltyApplied(address operator, uint256 amount);

    modifier onlyAdmin() {
        require(msg.sender == steward || msg.sender == regulator, "Not admin");
        _;
    }

    constructor(uint8 _minPairingPercent) {
        steward = msg.sender;
        minPairingPercent = _minPairingPercent;
    }

    function registerDC(address dc, address op, string calldata name) external onlyAdmin {
        dataCenters[dc] = DC(name, op, true, 0, 0);
        emit Registered(dc, op, name);
    }

    function reportUsage(address dc, uint256 consumed, uint256 paired) external onlyAdmin {
        DC storage d = dataCenters[dc];
        d.consumedMWh += consumed;
        d.pairedMWh += paired;

        uint8 ratio = uint8((paired * 100) / consumed);
        if (ratio < minPairingPercent) {
            uint256 penalty = (minPairingPercent - ratio) * consumed * 1e15;
            penaltiesDue[d.operator] += penalty;
            emit PenaltyApplied(d.operator, penalty);
        }
        emit UsageReported(dc, consumed, paired);
    }
}
