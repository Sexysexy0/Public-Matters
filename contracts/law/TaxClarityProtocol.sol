// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title TaxClarityProtocol
 * @author Vinvin Gueco
 * @notice Ritualized contract for crypto tax transparency and retail protection
 */

contract TaxClarityProtocol {
    address public steward;
    uint256 public flatTaxRate = 1750; // 17.5% represented as basis points
    uint256 public exemptionThreshold = 1000 * 1e18; // Exempt if gains < $1000 equivalent
    mapping(address => uint256) public reportedGains;
    mapping(address => bool) public exemptStatus;

    event TaxReported(address indexed trader, uint256 gain, uint256 taxDue);
    event ExemptionGranted(address indexed trader);
    event AuditTriggered(address indexed trader, string reason);

    constructor() {
        steward = msg.sender;
    }

    function reportGain(uint256 gainAmount) external {
        reportedGains[msg.sender] = gainAmount;
        if (gainAmount < exemptionThreshold) {
            exemptStatus[msg.sender] = true;
            emit ExemptionGranted(msg.sender);
        } else {
            uint256 taxDue = (gainAmount * flatTaxRate) / 10000;
            emit TaxReported(msg.sender, gainAmount, taxDue);
        }
    }

    function triggerAudit(address trader, string calldata reason) external {
        require(msg.sender == steward, "Only steward may audit");
        emit AuditTriggered(trader, reason);
    }

    function getTaxSummary(address trader) external view returns (string memory summary) {
        if (exemptStatus[trader]) {
            summary = "Trader is exempt from crypto tax under damay clause.";
        } else {
            uint256 gain = reportedGains[trader];
            uint256 tax = (gain * flatTaxRate) / 10000;
            summary = string(abi.encodePacked("Reported gain: ", uint2str(gain), " wei. Tax due: ", uint2str(tax), " wei."));
        }
    }

    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) return "0";
        uint256 j = _i;
        uint256 len;
        while (j != 0) { len++; j /= 10; }
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
