// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./ICEAssetMobilization.sol";
import "./APROracle.sol";
import "./CivicOracle.sol";

contract DeportationOverride {
    address public steward;
    ICEAssetMobilization public assetModule;
    APROracle public aprOracle;
    CivicOracle public civicOracle;

    struct DeportationRequest {
        string caseID;
        address subject;
        bool reEntryRegistered;
        bool emergencyFlag;
        uint256 aprScore;
        bool blessed;
    }

    mapping(address => DeportationRequest) public requests;

    event DeportationLogged(address indexed subject, string caseID, bool blessed);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor(address _assetModule, address _aprOracle, address _civicOracle) {
        steward = msg.sender;
        assetModule = ICEAssetMobilization(_assetModule);
        aprOracle = APROracle(_aprOracle);
        civicOracle = CivicOracle(_civicOracle);
    }

    function submitRequest(
        string memory caseID,
        address subject,
        bool reEntryRegistered,
        bool emergencyFlag
    ) public onlySteward {
        uint256 aprScore = aprOracle.getAPR(subject);
        bool blessed = civicOracle.validateDeportation(caseID, subject, emergencyFlag);

        requests[subject] = DeportationRequest({
            caseID: caseID,
            subject: subject,
            reEntryRegistered: reEntryRegistered,
            emergencyFlag: emergencyFlag,
            aprScore: aprScore,
            blessed: blessed
        });

        if (blessed && (!reEntryRegistered || emergencyFlag)) {
            assetModule.mobilizeAssets(subject, "Deportation");
            emit DeportationLogged(subject, caseID, blessed);
        }
    }

    function getRequest(address subject) public view returns (DeportationRequest memory) {
        return requests[subject];
    }
}
