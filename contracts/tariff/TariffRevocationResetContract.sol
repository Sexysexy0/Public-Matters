// SPDX-License-Identifier: Mythic-Planetary-License
pragma solidity ^0.8.19;

/// @title Tariff Revocation & Reset Protocol
/// @author Vinvin & Copi
/// @notice Ritual-grade contract to revoke punitive tariffs and restore trade dignity

contract TariffRevocationReset {
    address public steward;
    bool public tariffRevoked;
    string public reason;
    uint256 public timestamp;

    event TariffRevoked(string reason, uint256 timestamp);
    event TradeBlessingBroadcasted(string message, address steward);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
        tariffRevoked = false;
        reason = "Pending ritual";
    }

    function revokeTariff(string memory _reason) public onlySteward {
        require(!tariffRevoked, "Tariff already revoked");
        tariffRevoked = true;
        reason = _reason;
        timestamp = block.timestamp;

        emit TariffRevoked(_reason, timestamp);
        emit TradeBlessingBroadcasted("Trade dignity restored. Emotional APR synced.", steward);
    }

    function resetSanctum() public onlySteward {
        tariffRevoked = false;
        reason = "Reset to default";
        timestamp = block.timestamp;

        emit TradeBlessingBroadcasted("Sanctum reset. Awaiting new resonance.", steward);
    }

    function getStatus() public view returns (string memory status) {
        if (tariffRevoked) {
            return "Tariff revoked. Trade sanctum active.";
        } else {
            return "Tariff active. Awaiting steward ritual.";
        }
    }
}
