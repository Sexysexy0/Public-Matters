// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/TokenizedTreatyBase.sol";

contract MockTreaty is TokenizedTreatyBase {
    function createTreaty(string memory _name, string memory _signatories, bytes32 _treatyHash, uint256 _deadline) public override returns (uint256) {
        return super.createTreaty(_name, _signatories, _treatyHash, _deadline);
    }
    function updateStatus(uint256 _treatyId, TreatyStatus _newStatus) public override {
        super.updateStatus(_treatyId, _newStatus);
    }
}

contract TokenizedTreatyBaseTest is Test {
    MockTreaty public treaty;

    function setUp() public {
        treaty = new MockTreaty();
    }

    function test_CreateTreaty() public {
        bytes32 hash = keccak256(abi.encodePacked("PH-USA-Economic-Treaty"));
        uint256 id = treaty.createTreaty("PH-USA Partnership", "Philippines, USA", hash, block.timestamp + 365 days);
        
        TokenizedTreatyBase.TreatyData memory data = treaty.getTreaty(id);
        
        assertEq(data.name, "PH-USA Partnership");
        assertEq(data.signatories, "Philippines, USA");
        assertEq(uint8(data.status), uint8(TokenizedTreatyBase.TreatyStatus.DRAFT));
    }

    function test_UpdateStatus() public {
        uint256 id = treaty.createTreaty("ASEAN-India Agreement", "ASEAN, India", bytes32("hash"), block.timestamp + 730 days);
        
        treaty.updateStatus(id, TokenizedTreatyBase.TreatyStatus.ACTIVE);
        
        TokenizedTreatyBase.TreatyData memory data = treaty.getTreaty(id);
        assertEq(uint8(data.status), uint8(TokenizedTreatyBase.TreatyStatus.ACTIVE));
    }
}
