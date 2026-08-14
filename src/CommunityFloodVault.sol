// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrustIntegrator} from "./ITrustIntegrator.sol";

contract CommunityFloodVault {
    ITrustIntegrator public trustIntegrator;
    address public steward;

    struct Init {
        address contractorOrLeader;
        uint256 amount;
    }

    event ReliefInitiated(address indexed initiator, uint256 amount);

    modifier onlySteward() {
        require(msg.sender == steward, "Only steward");
        _;
    }

    constructor(address _trustIntegrator) {
        steward = msg.sender;
        trustIntegrator = ITrustIntegrator(_trustIntegrator);
    }

    function initiateRelief(Init calldata init) external onlySteward {
        // Log positive action with string description
        trustIntegrator.logPositiveAction(
            string(abi.encodePacked("Relief: ", Strings.toHexString(init.contractorOrLeader))),
            3
        );
        emit ReliefInitiated(init.contractorOrLeader, init.amount);
    }

    function setTrustIntegrator(address _new) external onlySteward {
        trustIntegrator = ITrustIntegrator(_new);
    }
}

// Helper library for string conversion
library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    function toHexString(address addr) internal pure returns (string memory) {
        return toHexString(abi.encodePacked(addr));
    }

    function toHexString(bytes memory data) internal pure returns (string memory) {
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
