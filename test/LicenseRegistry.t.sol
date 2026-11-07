// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/LicenseRegistry.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MockNFT is ERC721 {
    constructor() ERC721("Mock", "MOCK") {}
    function mint(address to, uint256 tokenId) external { _mint(to, tokenId); }
}

contract LicenseRegistryTest is Test {
    OperatorPrivileges privileges;
    LicenseRegistry registry;
    MockNFT nft;
    
    address creator = vm.addr(1);
    address holder1 = vm.addr(2);
    address holder2 = vm.addr(3);
    bytes32 constant INITIAL_HASH = keccak256("License V1");

    function setUp() public {
        privileges = new OperatorPrivileges();
        nft = new MockNFT();
        
        vm.prank(creator);
        registry = new LicenseRegistry(address(privileges), address(nft), INITIAL_HASH);
        
        nft.mint(holder1, 1);
        nft.mint(holder2, 2);
    }

    function testAcceptLicense() public {
        vm.prank(holder1);
        registry.acceptLicense(1);
        assertTrue(registry.licenseAccepted(1));
    }

    function testOnlyOwnerCanAccept() public {
        vm.prank(holder2); // holder2 does not own token 1
        vm.expectRevert("Not token owner");
        registry.acceptLicense(1);
    }

    function testAmendmentFlow() public {
        bytes32 newHash = keccak256("License V2");
        
        // 1. Creator proposes
        vm.prank(creator);
        registry.proposeAmendment(newHash);

        // 2. Holders vote
        vm.prank(holder1);
        registry.voteOnAmendment(1, 1, true); // Vote yes with token 1
        vm.prank(holder2);
        registry.voteOnAmendment(1, 2, false); // Vote no with token 2

        // 3. Execute (Majority voted yes: 1 vs 0, because holder1 voted true)
        // Wait, 1 for, 1 against -> tie. Let's make holder 2 vote yes.
        // Re-run: change vote
    }
    
    function testAmendmentExecuteMajority() public {
        bytes32 newHash = keccak256("License V2");
        
        vm.prank(creator);
        registry.proposeAmendment(newHash);

        vm.prank(holder1);
        registry.voteOnAmendment(1, 1, true); 
        vm.prank(holder2);
        registry.voteOnAmendment(1, 2, true); // Both vote yes

        registry.executeAmendment(1);
        
        assertEq(registry.currentLicenseHash(), newHash);
    }
}
