// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrustIntegrator} from "./ITrustIntegrator.sol";

contract HospitalClaimEscrow {
    ITrustIntegrator public trustIntegrator;
    address public steward;

    event ClaimProcessed(address indexed patient, uint256 amount);

    modifier onlySteward() {
        require(msg.sender == steward, "Only steward");
        _;
    }

    constructor(address _trustIntegrator) {
        steward = msg.sender;
        trustIntegrator = ITrustIntegrator(_trustIntegrator);
    }

    function processClaim(address patient, uint256 amount) external onlySteward {
        trustIntegrator.logPositiveAction(
            string(abi.encodePacked("Claim: ", Strings.toHexString(patient))),
            20
        );
        emit ClaimProcessed(patient, amount);
    }

    function setTrustIntegrator(address _new) external onlySteward {
        trustIntegrator = ITrustIntegrator(_new);
    }
}

library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    function toHexString(address addr) internal pure returns (string memory) {
        bytes memory data = abi.encodePacked(addr);
        bytes memory result = new bytes(2 + data.length * 2);
        result[0] = "0";
        result[1] = "x";
        for (uint256 i = 0; i < data.length; i++) {
            result[2 + i * 2] = _HEX_SYMBOLS[uint8(data[i] >> 4)];
            result[3 + i * 2] = _HEX_SYMBOLS[uint8(data[i] & 0x0f)];
        }
        return string(result);
    }
}
