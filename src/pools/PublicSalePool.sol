// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.24;

import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {FishcakeCoin} from "../Token/FishcakeCoin.sol";
import {RedemptionPool} from "./RedemptionPool.sol";
import {IPublicSalePool} from "./interfaces/IPublicSalePool.sol";

contract PublicSalePool is IPublicSalePool {
    using SafeERC20 for ERC20;

    ERC20 public USDT = ERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);

    FishcakeCoin public fishcakeCoin;
    RedemptionPool public redemptionPool;

    constructor(address _fishcakeCoin, address _redemptionPool) {
        fishcakeCoin = FishcakeCoin(_fishcakeCoin);
        redemptionPool = RedemptionPool(_redemptionPool);
    }

    function Buy(uint256 _amount) external {
        uint256 USDTAmount = _amount / (10 ** 12) / 10; // 1FCC = 0.1 USDT
        if (_amount > fishcakeCoin.balanceOf(address(this))) {
            revert NotEnoughFishcakeCoin();
        }
        USDT.safeTransferFrom(msg.sender, address(this), USDTAmount);
        USDT.transfer(address(redemptionPool), USDTAmount);

        fishcakeCoin.transfer(msg.sender, _amount);

        emit BuyFishcakeCoinSuccess(msg.sender, USDTAmount, _amount);
    }

    function BuyWithUSDT(uint256 _amount) external {
        uint256 fishcakeCoinAmount = _amount * 10 * 10 ** 12; // 1 USDT = 10 FCC
        if (fishcakeCoinAmount > fishcakeCoin.balanceOf(address(this))) {
            revert NotEnoughFishcakeCoin();
        }
        USDT.safeTransferFrom(msg.sender, address(this), _amount);
        USDT.transfer(address(redemptionPool), _amount);

        fishcakeCoin.transfer(msg.sender, fishcakeCoinAmount);

        emit BuyFishcakeCoinSuccess(msg.sender, _amount, fishcakeCoinAmount);
    }
}
