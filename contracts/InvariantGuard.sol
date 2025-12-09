// contracts/InvariantGuard.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IPair {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function token0() external view returns (address);
    function token1() external view returns (address);
}

library InvariantGuard {
    error ReserveMismatch(address pair, uint256 bal0, uint256 bal1, uint256 r0, uint256 r1);

    function assertSync(address pair) internal view {
        IPair p = IPair(pair);
        (uint112 r0, uint112 r1,) = p.getReserves();
        address t0 = p.token0();
        address t1 = p.token1();
        uint256 bal0 = IERC20(t0).balanceOf(pair);
        uint256 bal1 = IERC20(t1).balanceOf(pair);
        if (bal0 != uint256(r0) || bal1 != uint256(r1)) {
            revert ReserveMismatch(pair, bal0, bal1, r0, r1);
        }
    }
}

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}
