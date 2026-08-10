// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ArnoProtocol
 * @dev Redemption archetype: allows guilty actors to stake collateral for forgiveness.
 */
contract ArnoProtocol {
    address public overseer;
    mapping(address => uint256) public collateral;

    event Redemption(address indexed actor, uint256 amount);
    event Forgiveness(address indexed actor);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Only overseer");
        _;
    }

    constructor() {
        overseer = msg.sender;
    }

    function redemption(address actor, uint256 amount) external onlyOverseer {
        collateral[actor] += amount;
        emit Redemption(actor, amount);
    }

    function forgive(address actor) external onlyOverseer {
        require(collateral[actor] > 0, "No collateral staked");
        collateral[actor] = 0;
        emit Forgiveness(actor);
    }
}
