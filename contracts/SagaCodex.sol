// Copyright (c) 2026 Emervin V. Gueco (Vinvin). All rights reserved.
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title SagaCodex
/// @notice Covenant contract to symbolically safeguard mythic journey of Kratos: vengeance, redemption, and godhood
contract SagaCodex {
    address public overseer;
    uint256 public sagaCount;

    struct SagaRule {
        uint256 id;
        string principle; // Greek Vengeance, Norse Redemption, Fatherhood, Godhood of Hope
        string description; // encoded saga safeguard
        uint256 timestamp;
    }

    mapping(uint256 => SagaRule) public sagas;

    event SagaLogged(uint256 indexed id, string principle, string description);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function logSaga(
        string calldata principle,
        string calldata description
    ) external onlyOverseer {
        sagaCount++;
        sagas[sagaCount] = SagaRule({
            id: sagaCount,
            principle: principle,
            description: description,
            timestamp: block.timestamp
        });
        emit SagaLogged(sagaCount, principle, description);
    }

    function viewSaga(uint256 id) external view returns (SagaRule memory) {
        return sagas[id];
    }
}
