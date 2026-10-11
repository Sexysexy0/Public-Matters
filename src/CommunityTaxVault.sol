// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ICommunityDAO} from "./ICommunityDAO.sol";
import {ITrustIntegrator} from "./ITrustIntegrator.sol";

contract CommunityTaxVault {
    address public steward;
    ICommunityDAO public communityDAO;
    ITrustIntegrator public trustIntegrator;
    uint256 public totalTaxCollected;

    mapping(address => bool) public authorizedAllocators;

    event TaxDeposited(address indexed payer, uint256 amount, uint256 trustWeight);
    event FundsAllocated(address indexed recipient, uint256 amount, string proposal);
    event AuthorizedAllocatorAdded(address allocator);
    event AuthorizedAllocatorRemoved(address allocator);

    modifier onlySteward() {
        require(msg.sender == steward, "Only steward");
        _;
    }

    modifier onlyAuthorized() {
        require(
            msg.sender == steward || msg.sender == address(communityDAO) || authorizedAllocators[msg.sender],
            "Not authorized"
        );
        _;
    }

    constructor(address _communityDAO, address _trustIntegrator) {
        steward = msg.sender;
        communityDAO = ICommunityDAO(_communityDAO);
        trustIntegrator = ITrustIntegrator(_trustIntegrator);
    }

    function depositTax() public payable {
        require(msg.value > 0, "Amount must be > 0");
        totalTaxCollected += msg.value;

        uint256 trustWeight = msg.value / 1e16;
        if (trustWeight == 0) trustWeight = 1;

        trustIntegrator.logPositiveAction(string(abi.encodePacked("Tax deposit: ", msg.sender)), trustWeight);

        emit TaxDeposited(msg.sender, msg.value, trustWeight);
    }

    function allocateFunds(address payable recipient, uint256 amount, string calldata proposal) external onlyAuthorized {
        require(recipient != address(0), "recipient=0");
        require(amount <= totalTaxCollected, "Insufficient funds");

        // CEI: state change before external call
        totalTaxCollected -= amount;

        emit FundsAllocated(recipient, amount, proposal);

        (bool ok, ) = recipient.call{value: amount}("");
        require(ok, "Transfer failed");
    }

    // Authorize a contract or address to allocate funds
    function addAuthorizedAllocator(address allocator) external onlySteward {
        authorizedAllocators[allocator] = true;
        emit AuthorizedAllocatorAdded(allocator);
    }

    function removeAuthorizedAllocator(address allocator) external onlySteward {
        authorizedAllocators[allocator] = false;
        emit AuthorizedAllocatorRemoved(allocator);
    }

    function setCommunityDAO(address _new) external onlySteward {
        communityDAO = ICommunityDAO(_new);
    }

    function setTrustIntegrator(address _new) external onlySteward {
        trustIntegrator = ITrustIntegrator(_new);
    }

    receive() external payable {
        depositTax();
    }
}
