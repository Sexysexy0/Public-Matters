// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract PriceFairness is Ownable {
    struct PriceEvent {
        uint256 id;
        string vendor;
        string competitor;
        uint256 oldPrice;
        uint256 newPrice;
        bool coerced;
    }

    uint256 public eventCount;
    mapping(uint256 => PriceEvent) private events;

    event PriceLogged(
        uint256 id,
        string vendor,
        string competitor,
        uint256 oldPrice,
        uint256 newPrice,
        bool coerced
    );

    constructor(address lead) Ownable(lead) {}

    function logPriceEvent(
        string calldata _vendor,
        string calldata _competitor,
        uint256 _oldPrice,
        uint256 _newPrice,
        bool _coerced
    ) external onlyOwner {
        eventCount++;
        events[eventCount] = PriceEvent(
            eventCount,
            _vendor,
            _competitor,
            _oldPrice,
            _newPrice,
            _coerced
        );
        emit PriceLogged(eventCount, _vendor, _competitor, _oldPrice, _newPrice, _coerced);
    }

    /// ✅ Getter para ma‑access ang struct sa tests
    function getEvent(uint256 id) external view returns (PriceEvent memory) {
        return events[id];
    }
}
