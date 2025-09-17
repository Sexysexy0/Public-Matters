// SPDX-License-Identifier: WageSanctum
pragma solidity ^0.8.19;

contract PasahodBroadcast {
    address public steward;
    uint256 public totalReleases;

    struct WageRelease {
        address recipient;
        uint256 amount;
        string role;
        uint256 timestamp;
        bool verified;
    }

    WageRelease[] public releases;

    event WageReleased(address indexed recipient, uint256 amount, string role, uint256 timestamp);
    event WageVerified(uint256 indexed index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function releaseWage(address _recipient, uint256 _amount, string memory _role) public {
        require(msg.sender == steward, "Only steward may release wages");
        releases.push(WageRelease(_recipient, _amount, _role, block.timestamp, false));
        totalReleases++;
        emit WageReleased(_recipient, _amount, _role, block.timestamp);
    }

    function verifyWage(uint256 index) public {
        require(index < releases.length, "Invalid index");
        releases[index].verified = true;
        emit WageVerified(index, msg.sender);
    }

    function getWageRelease(uint256 index) public view returns (address, uint256, string memory, uint256, bool) {
        WageRelease memory w = releases[index];
        return (w.recipient, w.amount, w.role, w.timestamp, w.verified);
    }
}
