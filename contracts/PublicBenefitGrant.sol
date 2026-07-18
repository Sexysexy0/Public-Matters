// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PublicBenefitGrant {
    struct Grant {
        address institution;
        uint256 releaseAmount;
    }

    mapping(uint256 => Grant) public grants;
    uint256 public totalGrants;

    event GrantReleased(uint256 indexed id, address indexed institution, uint256 amount);

    function configureGrant(address _institution, uint256 _amount) public {
        totalGrants++;
        grants[totalGrants] = Grant({institution: _institution, releaseAmount: _amount});
    }

    function releaseGrant(uint256 _id) public {
        Grant storage g = grants[_id];
        require(g.releaseAmount > 0, "No grant configured");

        (bool success, ) = payable(g.institution).call{value: g.releaseAmount}("");
        require(success, "Transfer failed");

        emit GrantReleased(_id, g.institution, g.releaseAmount);
    }

    receive() external payable {}
}
