// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./EmotionalAPR.sol";
import "./BlessingRegistry.sol";
import "./GeoSanctionOracle.sol";

contract SanctumCargoAudit {
    struct Cargo {
        string manifestHash;
        string originCountry;
        string destinationSanctum;
        bool blessed;
        bool rogueFlag;
        uint emotionalAPR;
        uint timestamp;
    }

    mapping(bytes32 => Cargo) public cargoLedger;
    address public steward;

    event CargoLogged(bytes32 indexed cargoId, string origin, string destination, bool blessed, bool rogueFlag, uint emotionalAPR);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logCargo(
        bytes32 cargoId,
        string memory manifestHash,
        string memory originCountry,
        string memory destinationSanctum,
        bool blessed
    ) public onlySteward {
        bool rogueFlag = GeoSanctionOracle.isSanctioned(originCountry);
        uint emotionalAPR = EmotionalAPR.calculate(manifestHash);

        cargoLedger[cargoId] = Cargo(
            manifestHash,
            originCountry,
            destinationSanctum,
            blessed,
            rogueFlag,
            emotionalAPR,
            block.timestamp
        );

        emit CargoLogged(cargoId, originCountry, destinationSanctum, blessed, rogueFlag, emotionalAPR);
    }

    function auditCargo(bytes32 cargoId) public view returns (Cargo memory) {
        return cargoLedger[cargoId];
    }
}
