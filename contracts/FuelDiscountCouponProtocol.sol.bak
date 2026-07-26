pragma solidity ^0.8.0;

contract FuelDiscountCouponProtocol {
    event CouponIssued(string recipient, uint256 discountRate, string validity);

    function issueCoupon(string memory recipient, bool usesFuel) public {
        if (usesFuel) {
            emit CouponIssued(recipient, 40, "Valid weekly for 1 year");
        }
    }
}
