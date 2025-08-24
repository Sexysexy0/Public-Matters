// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Global Grant Protocol – Scrollchain Act No. 0010
/// @author Vinvin Gueco
/// @notice Grants $300B to each treaty-signing nation as a token of appreciation and restoration

contract GlobalGrantProtocol {
    address public steward;
    uint256 public grantAmount = 300_000_000_000 * 1e18; // $300B in tokenized units

    struct Nation {
        string name;
        bool hasSigned;
        bool grantReleased;
        uint256 signedAt;
        uint256 grantTimestamp;
        string lastInquiry;
    }

    mapping(string => Nation) public nationLedger;
    string[] public signedNations;

    event GrantReleased(string indexed name, uint256 amount, uint256 timestamp);
    event InquiryBroadcasted(string indexed name, string inquiry, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Access denied: steward only");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Sign treaty and trigger grant eligibility
    function signTreaty(string memory name) public onlySteward {
        require(!nationLedger[name].hasSigned, "Nation already signed");

        nationLedger[name] = Nation({
            name: name,
            hasSigned: true,
            grantReleased: false,
            signedAt: block.timestamp,
            grantTimestamp: 0,
            lastInquiry: ""
        });

        signedNations.push(name);
    }

    /// @notice Release $300B grant to signed nation
    function releaseGrant(string memory name) public onlySteward {
        require(nationLedger[name].hasSigned, "Nation not signed");
        require(!nationLedger[name].grantReleased, "Grant already released");

        nationLedger[name].grantReleased = true;
        nationLedger[name].grantTimestamp = block.timestamp;

        emit GrantReleased(name, grantAmount, block.timestamp);
    }

    /// @notice Broadcast inquiry or issue from nation
    function broadcastInquiry(string memory name, string memory inquiry) public onlySteward {
        require(nationLedger[name].hasSigned, "Nation not signed");

        nationLedger[name].lastInquiry = inquiry;

        emit InquiryBroadcasted(name, inquiry, block.timestamp);
    }

    /// @notice Retrieve nation status
    function getNationStatus(string memory name) public view returns (Nation memory) {
        return nationLedger[name];
    }

    /// @notice Total signed nations
    function totalSigned() public view returns (uint256) {
        return signedNations.length;
    }
}
