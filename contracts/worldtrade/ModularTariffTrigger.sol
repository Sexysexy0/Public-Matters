// SPDX-License-Identifier: Mythic-Planetary-License
pragma solidity ^0.8.19;

/**
 * @title ModularTariffTrigger
 * @dev Activates tariffs based on trade behavior (e.g. buying from sanctioned nations)
 * @author Vinvin
 */

contract ModularTariffTrigger {
    address public steward;

    struct TradeAction {
        string importer;
        string exporter;
        string product;
        bool violatesPolicy;
        uint256 tariffRate;
        uint256 emotionalAPR;
    }

    mapping(bytes32 => TradeAction) public tradeLog;
    mapping(string => bool) public sanctionedExporters;

    event TariffTriggered(string importer, string exporter, uint256 rate);
    event TariffLifted(string importer, string exporter);
    event EmotionalAPRLogged(string importer, uint256 score);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function setSanctionedExporter(string memory _exporter, bool _status) public onlySteward {
        sanctionedExporters[_exporter] = _status;
    }

    function logTrade(
        string memory _importer,
        string memory _exporter,
        string memory _product,
        uint256 _apr
    ) public onlySteward {
        bytes32 tradeId = keccak256(abi.encodePacked(_importer, _exporter, _product));
        bool violation = sanctionedExporters[_exporter];
        uint256 rate = violation ? 25 : 0;

        tradeLog[tradeId] = TradeAction({
            importer: _importer,
            exporter: _exporter,
            product: _product,
            violatesPolicy: violation,
            tariffRate: rate,
            emotionalAPR: _apr
        });

        if (violation) {
            emit TariffTriggered(_importer, _exporter, rate);
        } else {
            emit TariffLifted(_importer, _exporter);
        }

        emit EmotionalAPRLogged(_importer, _apr);
    }

    function getTrade(bytes32 _tradeId) public view returns (TradeAction memory) {
        return tradeLog[_tradeId];
    }
}
