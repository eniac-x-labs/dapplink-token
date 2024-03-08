// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.24;

interface IRedemptionPool {
    event ClaimSuccess(address indexed user, uint256 USDTAmount, uint256 fishcakeCoinAmount);

    error USDTAmountIsZero();
    error NotEnoughUSDT();

    function claim(uint256 amount) external;

    function balance() external view returns (uint256);

    function calculateUSDT(uint256 amount) external view returns (uint256);
}
