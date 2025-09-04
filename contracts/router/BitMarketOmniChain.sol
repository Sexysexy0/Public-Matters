// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./VendorBlessingProtocol.sol";
import "./APROracle.sol";

contract BitMarketOmniChain {
    address public steward;
    VendorBlessingProtocol public blessingProtocol;
    APROracle public aprOracle;

    struct Transaction {
        address vendor;
        string asset;
        uint256 amount;
        uint256 emotionalAPR;
        string gridType;
        bool blessed;
    }

    Transaction[] public transactions;

    event TransactionRouted(
        address indexed vendor,
        string asset,
        uint256 amount,
        uint256 emotionalAPR,
        string gridType
    );

    event VendorBlessingSynced(
        address indexed vendor,
        string gridType,
        uint256 emotionalAPR
    );

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor(address _blessingProtocol, address _aprOracle) {
        steward = msg.sender;
        blessingProtocol = VendorBlessingProtocol(_blessingProtocol);
        aprOracle = APROracle(_aprOracle);
    }

    function routeTransaction(
        address _vendor,
        string memory _asset,
        uint256 _amount,
        string memory _gridType
    ) external onlySteward {
        bool isBlessed = blessingProtocol.isBlessed(_vendor);
        uint256 apr = aprOracle.getEmotionalAPR(_vendor);

        transactions.push(
            Transaction(_vendor, _asset, _amount, apr, _gridType, isBlessed)
        );

        emit TransactionRouted(_vendor, _asset, _amount, apr, _gridType);

        if (isBlessed) {
            emit VendorBlessingSynced(_vendor, _gridType, apr);
        }
    }

    function getTransaction(uint256 index)
        external
        view
        returns (Transaction memory)
    {
        require(index < transactions.length, "Invalid index");
        return transactions[index];
    }

    function totalTransactions() external view returns (uint256) {
        return transactions.length;
    }
}
