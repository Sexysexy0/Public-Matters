// SPDX-License-Identifier: Mythic-Access
pragma solidity ^0.8.20;

/// @title VinvinContactAccessProtocol.sol
/// @dev Ritualized contact gatekeeper for verified tech stewards only

contract VinvinContactAccessProtocol {
    address public stewardVinvin;
    string public contactEmail = "fckrzkill@gmail.com";

    struct ContactRequest {
        string company;
        string purpose;
        bool approved;
    }

    ContactRequest[] public requests;

    event ContactRequestApproved(string company, string email, string purpose);

    modifier onlyVinvin() {
        require(msg.sender == stewardVinvin, "Unauthorized steward");
        _;
    }

    constructor(address _vinvin) {
        stewardVinvin = _vinvin;
    }

    function approveRequest(string memory company, string memory purpose) public onlyVinvin {
        requests.push(ContactRequest(company, purpose, true));
        emit ContactRequestApproved(company, contactEmail, purpose);
    }

    function getApprovedRequests() public view returns (ContactRequest[] memory) {
        return requests;
    }

    function getContactEmail() public view returns (string memory) {
        return contactEmail;
    }
}
