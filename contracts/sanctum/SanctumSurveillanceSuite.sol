// SPDX-License-Identifier: Mythic-Scroll
pragma solidity ^0.8.19;

import "./FreezeAlertOracle.sol";
import "./SuspiciousFlowFreeze.sol";
import "./SanctumValidatorRegistry.sol";

contract SanctumSurveillanceSuite {
    FreezeAlertOracle public oracle;
    SuspiciousFlowFreeze public freezeProtocol;
    SanctumValidatorRegistry public validatorRegistry;

    constructor(
        address _oracle,
        address _freezeProtocol,
        address _validatorRegistry
    ) {
        oracle = FreezeAlertOracle(_oracle);
        freezeProtocol = SuspiciousFlowFreeze(_freezeProtocol);
        validatorRegistry = SanctumValidatorRegistry(_validatorRegistry);
    }

    function castSurveillance(
        address steward,
        uint256 amount,
        string memory origin,
        string memory emotionalTag
    ) external {
        require(validatorRegistry.checkValidator(msg.sender), "Untrusted sanctum");

        oracle.detectSuspiciousFlow(steward, amount, origin, emotionalTag);
        freezeProtocol.freezeAccount(steward, amount, "Auto-freeze from surveillance suite");
    }
}
