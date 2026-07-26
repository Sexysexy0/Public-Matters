// CapitalPreservationCharter.sol
pragma solidity ^0.8.0;

contract CapitalPreservationCharter {
    struct Reserve {
        uint256 id;
        string asset;      // e.g. "Emergency Fund"
        uint256 amount;    // e.g. 200000 (PHP)
        bool secured;
        uint256 timestamp;
    }

    uint256 public reserveCount;
    mapping(uint256 => Reserve) public reserves;

    event ReserveSecured(uint256 id, string asset, uint256 amount);

    function secureReserve(string memory asset, uint256 amount) public {
        reserveCount++;
        reserves[reserveCount] = Reserve(reserveCount, asset, amount, true, block.timestamp);
        emit ReserveSecured(reserveCount, asset, amount);
    }
}
