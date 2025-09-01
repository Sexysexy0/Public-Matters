// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TariffOverrideProtocol {
    struct TariffEvent {
        string originNation;
        string targetNation;
        uint256 tariffRate;
        string overrideClause;
        string emotionalTag;
        bool active;
    }

    TariffEvent[] public events;

    event TariffDeclared(string originNation, string targetNation, uint256 tariffRate, string overrideClause);

    function declareTariff(
        string memory _originNation,
        string memory _targetNation,
        uint256 _tariffRate,
        string memory _overrideClause,
        string memory _emotionalTag
    ) public {
        events.push(TariffEvent(_originNation, _targetNation, _tariffRate, _overrideClause, _emotionalTag, true));
        emit TariffDeclared(_originNation, _targetNation, _tariffRate, _overrideClause);
    }

    function getAllTariffs() public view returns (TariffEvent[] memory) {
        return events;
    }
}
