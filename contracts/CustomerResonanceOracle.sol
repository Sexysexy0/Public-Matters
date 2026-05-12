// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CustomerResonanceOracle {
    struct CustomerResonance {
        address overseer;
        string customer;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    CustomerResonance[] public customers;

    event CustomerResonanceLogged(address indexed overseer, string customer, string safeguard);
    event CustomerResonanceSafeguarded(uint256 indexed id, address verifier);

    function logCustomerResonance(string memory _customer, string memory _safeguard) public {
        customers.push(CustomerResonance(msg.sender, _customer, _safeguard, block.timestamp, false));
        emit CustomerResonanceLogged(msg.sender, _customer, _safeguard);
    }

    function safeguardCustomerResonance(uint256 _id) public {
        require(_id < customers.length, "Invalid ID");
        customers[_id].safeguarded = true;
        emit CustomerResonanceSafeguarded(_id, msg.sender);
    }

    function getCustomerResonance(uint256 _id) public view returns (CustomerResonance memory) {
        require(_id < customers.length, "Invalid ID");
        return customers[_id];
    }

    function totalCustomers() public view returns (uint256) {
        return customers.length;
    }
}
