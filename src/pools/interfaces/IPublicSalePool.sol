// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.24;

interface IPublicSalePool {
    event BuyFishcakeCoinSuccess(address indexed buyer, uint256 USDTAmount, uint256 fishcakeCoinAmount);

    error NotEnoughFishcakeCoin();

    function Buy(uint256 amount) external;

    function BuyWithUSDT(uint256 amount) external;
}
