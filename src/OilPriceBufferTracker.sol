// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

/**
 * @title OilPriceBufferTracker
 * @notice Sinusubaybayan ang paggalaw ng presyo ng petrolyo (Rollback/Hike) 
 * at nagbibigay ng awtomatikong adjustment sa transport/logistics subsidy budget.
 */
contract OilPriceBufferTracker {

    address public immutable steward;
    
    struct PriceLog {
        uint256 timestamp;
        int256 gasolineChange; // Pwede maging negative (rollback) o positive (hike) sa sentimos (centavo scale)
        int256 dieselChange;
        string reason;
    }

    PriceLog[] public priceHistory;
    mapping(string => uint256) public sectorSubsidies;

    event OilPriceUpdated(int256 gasChange, int256 dieselChange, string reason);
    event SubsidyAdjusted(string sector, uint256 newAllocation);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward access");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /**
     * @notice I-log ang pinakabagong oil price adjustment (hal. Rollback ngayong linggo)
     */
    function logPriceAdjustment(int256 _gasChange, int256 _dieselChange, string memory _reason) external onlySteward {
        priceHistory.push(PriceLog({
            timestamp: block.timestamp,
            gasolineChange: _gasChange,
            dieselChange: _dieselChange,
            reason: _reason
        }));

        emit OilPriceUpdated(_gasChange, _dieselChange, _reason);
    }

    /**
     * @notice Magtakda ng alokasyon o subsidy para sa transportasyon batay sa galaw ng presyo
     */
    function setSectorSubsidy(string memory sector, uint256 amount) external onlySteward {
        sectorSubsidies[sector] = amount;
        emit SubsidyAdjusted(sector, amount);
    }

    function getLatestPriceLog() external view returns (uint256, int256, int256, string memory) {
        require(priceHistory.length > 0, "No price logs available");
        PriceLog memory latest = priceHistory[priceHistory.length - 1];
        return (latest.timestamp, latest.gasolineChange, latest.dieselChange, latest.reason);
    }
}
