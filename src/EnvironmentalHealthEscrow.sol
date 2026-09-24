// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

contract EnvironmentalHealthEscrow {
    address public controller;
    event FundsConfiscated(bytes32 indexed projectId, address indexed target);

    constructor() {
        controller = msg.sender;
    }

    function confiscateForRemediation(bytes32 projectId, address payable target) external {
        require(msg.sender == controller, "Not controller");
        require(target != address(0), "Zero-address enforcement block");

        // Fixed: Emit event prior to performing the external ether transfer interaction
        emit FundsConfiscated(projectId, target);

        uint256 balance = address(this).balance;
        if (balance > 0) {
            (bool success, ) = target.call{value: balance}("");
            require(success, "Remediation fund transfer failed");
        }
    }

    receive() external payable {}
}
