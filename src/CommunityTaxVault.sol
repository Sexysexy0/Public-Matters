// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ICommunityDAO} from "./ICommunityDAO.sol";
import {ITrustIntegrator} from "./ITrustIntegrator.sol";

contract CommunityTaxVault {
    address public steward;
    ICommunityDAO public communityDAO;
    ITrustIntegrator public trustIntegrator;
    uint256 public totalTaxCollected;

    event TaxDeposited(address indexed payer, uint256 amount, uint256 trustWeight);
    event FundsAllocated(uint256 amount, string proposal);

    modifier onlySteward() {
        require(msg.sender == steward, "Only steward");
        _;
    }

    constructor(address _communityDAO, address _trustIntegrator) {
        steward = msg.sender;
        communityDAO = ICommunityDAO(_communityDAO);
        trustIntegrator = ITrustIntegrator(_trustIntegrator);
    }

    // Accept native ETH as tax payment – now public so receive can call it
    function depositTax() public payable {
        require(msg.value > 0, "Amount must be > 0");
        totalTaxCollected += msg.value;

        uint256 trustWeight = msg.value / 1e16;
        if (trustWeight == 0) trustWeight = 1;

        trustIntegrator.logPositiveAction(
            string(abi.encodePacked("Tax deposit: ", msg.sender)),
            trustWeight
        );

        emit TaxDeposited(msg.sender, msg.value, trustWeight);
    }

    function allocateFunds(uint256 amount, string calldata proposal) external {
        require(msg.sender == steward || msg.sender == address(communityDAO), "Not authorized");
        require(amount <= totalTaxCollected, "Insufficient funds");
        totalTaxCollected -= amount;
        emit FundsAllocated(amount, proposal);
    }

    // Allow contract to receive ETH directly – now calls depositTax() internally
    receive() external payable {
        depositTax();
    }

    function setCommunityDAO(address _new) external onlySteward {
        communityDAO = ICommunityDAO(_new);
    }

    function setTrustIntegrator(address _new) external onlySteward {
        trustIntegrator = ITrustIntegrator(_new);
    }
}
