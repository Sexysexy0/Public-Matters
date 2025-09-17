// SPDX-License-Identifier: DualCurrencySanctum
pragma solidity ^0.8.19;

contract FiatStablecoinCoexistenceRouter {
    address public steward;

    struct Activation {
        string region;
        string fiatType;
        string stablecoinType;
        string purpose;
        uint256 timestamp;
        bool verified;
    }

    Activation[] public activations;

    event ActivationLogged(string region, string fiatType, string stablecoinType, uint256 timestamp);
    event ActivationVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logActivation(
        string memory region,
        string memory fiatType,
        string memory stablecoinType,
        string memory purpose
    ) public {
        activations.push(Activation(region, fiatType, stablecoinType, purpose, block.timestamp, false));
        emit ActivationLogged(region, fiatType, stablecoinType, block.timestamp);
    }

    function verifyActivation(uint256 index) public {
        require(index < activations.length, "Invalid index");
        activations[index].verified = true;
        emit ActivationVerified(index, msg.sender);
    }

    function getActivation(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256, bool
    ) {
        Activation memory a = activations[index];
        return (a.region, a.fiatType, a.stablecoinType, a.purpose, a.timestamp, a.verified);
    }

    function totalActivations() public view returns (uint256) {
        return activations.length;
    }
}
