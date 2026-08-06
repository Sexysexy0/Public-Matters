// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GpuComputeEscrow {
    struct RentalSession {
        address provider;
        address client;
        uint256 ratePerHour;
        uint256 startTime;
        bool isActive;
    }

    mapping(bytes32 => RentalSession) public rentals;

    event SessionStarted(bytes32 indexed sessionId, address provider, address client);
    event SessionEnded(bytes32 indexed sessionId, uint256 totalCost);

    function startComputeRental(bytes32 sessionId, address provider, uint256 ratePerHour) external payable {
        require(msg.value >= ratePerHour, "Deposit at least 1 hour");
        require(!rentals[sessionId].isActive, "Session exists");

        rentals[sessionId] = RentalSession({
            provider: provider,
            client: msg.sender,
            ratePerHour: ratePerHour,
            startTime: block.timestamp,
            isActive: true
        });

        emit SessionStarted(sessionId, provider, msg.sender);
    }

    function stopComputeRental(bytes32 sessionId) external {
        RentalSession storage session = rentals[sessionId];
        require(session.isActive, "Session not active");
        require(msg.sender == session.client || msg.sender == session.provider, "Unauthorized");

        uint256 durationHours = (block.timestamp - session.startTime) / 3600;
        if (durationHours == 0) durationHours = 1;

        uint256 totalCost = durationHours * session.ratePerHour;
        session.isActive = false;

        (bool success, ) = payable(session.provider).call{value: totalCost}(""); require(success, "Transfer failed");

        emit SessionEnded(sessionId, totalCost);
    }
}
