// SPDX-License-Identifier: TariffSurvivalSanctifier
pragma solidity ^0.8.19;

contract TariffSurvivalSanctifier {
    address public steward;

    struct TariffSignal {
        string originNation; // e.g. "Australia"
        string targetNation; // e.g. "United States"
        string breachType; // e.g. "Steel Tariff 50%", "General Tariff 10%"
        string resilienceTag; // e.g. "DiplomaticUphill #DU7"
        bool verified;
        uint256 timestamp;
    }

    TariffSignal[] public signals;

    event TariffLogged(string originNation, string targetNation, string breachType, string resilienceTag, uint256 timestamp);
    event TariffVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logTariff(
        string memory originNation,
        string memory targetNation,
        string memory breachType,
        string memory resilienceTag
    ) public {
        signals.push(TariffSignal(originNation, targetNation, breachType, resilienceTag, false, block.timestamp));
        emit TariffLogged(originNation, targetNation, breachType, resilienceTag, block.timestamp);
    }

    function verifyTariff(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit TariffVerified(index, msg.sender);
    }

    function totalTariffSignals() public view returns (uint256) {
        return signals.length;
    }
}
