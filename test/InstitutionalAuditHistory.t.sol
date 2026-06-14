// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import "../contracts/InstitutionalAuditHistory.sol";
import "../contracts/WhistleblowerSanctuary.sol";
contract InstitutionalAuditHistoryTest is Test {
    InstitutionalAuditHistory public auditHistory;
    WhistleblowerSanctuary public sanctuary;
    address public guardianWallet = address(0x1111);
    address public whistleblower = address(0x2222);
    address public badInstitution = address(0x3333);
    bytes32 public intelHash = keccak256(abi.encodePacked("BREACH_OF_PROTOCOL_DATA"));
    function setUp() public {
        vm.startPrank(guardianWallet);
        auditHistory = new InstitutionalAuditHistory();
        sanctuary = new WhistleblowerSanctuary();
        sanctuary.setAuditHistoryAddress(address(auditHistory));
        auditHistory.setLoggerAuthorization(address(sanctuary), true);
        vm.stopPrank();
    }
    function test_CrossContractWarningLogging() public {
        vm.prank(whistleblower);
        sanctuary.submitIntel(intelHash, badInstitution);
        (uint256 freezes, uint256 grants, uint256 warnings, , , ) = auditHistory.viewHistory(badInstitution);
        assertEq(warnings, 1);
        assertEq(freezes, 0);
        assertEq(grants, 0);
    }
}
