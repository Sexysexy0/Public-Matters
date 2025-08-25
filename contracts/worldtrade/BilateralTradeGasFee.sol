// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

/// @title BilateralTradeGasFee
/// @author Vinvin
/// @notice Ritualizes trade with a shared 2% fee split between exporter and importer sanctums

contract BilateralTradeGasFee {
    address public stewardCouncil;
    uint256 public feePercent = 2;

    event TradeProcessed(
        address indexed exporter,
        address indexed importer,
        uint256 tradeValue,
        uint256 feeApplied,
        string aprTag,
        uint256 timestamp
    );

    modifier onlyCouncil() {
        require(msg.sender == stewardCouncil, "Unauthorized steward");
        _;
    }

    constructor(address _stewardCouncil) {
        stewardCouncil = _stewardCouncil;
    }

    function processTrade(
        address payable exporter,
        address payable importer,
        string memory aprTag
    ) external payable onlyCouncil {
        uint256 fee = (msg.value * feePercent) / 100;
        uint256 split = fee / 2;

        exporter.transfer(split);
        importer.transfer(split);

        emit TradeProcessed(exporter, importer, msg.value, fee, aprTag, block.timestamp);
    }

    fallback() external payable {
        revert("Unritualized trade attempt");
    }

    receive() external payable {}
}
