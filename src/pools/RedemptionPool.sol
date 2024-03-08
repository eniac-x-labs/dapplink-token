// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.24;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {FishcakeCoin} from "../Token/FishcakeCoin.sol";
import {IRedemptionPool} from "./interfaces/IRedemptionPool.sol";

contract RedemptionPool is IRedemptionPool {
    using SafeERC20 for ERC20;

    uint256 public constant TWO_YEARS = 730 days;
    uint256 public constant ONE_USDT = 10 ** 6;
    uint256 public constant ONE_FCC = 10 ** 18;

    ERC20 public USDT = ERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);

    uint256 public UnlockTime;
    FishcakeCoin public fishcakeCoin;

    modifier IsUnlock() {
        require(block.timestamp > UnlockTime, "Redemption is locked");
        _;
    }

    constructor(address _fishcakeCoin) {
        require(_fishcakeCoin != address(0), "_fishcakeCoin address can not be zero");
        fishcakeCoin = FishcakeCoin(_fishcakeCoin);
        UnlockTime = block.timestamp + TWO_YEARS;
    }

    function claim(uint256 _amount) external IsUnlock {
        require(_amount > 0, "Invalid amount");
        uint256 USDTAmount = _calculateUSDT(_amount);
        if (USDTAmount == 0) {
            revert USDTAmountIsZero();
        }
        if (USDTAmount > balance()) {
            revert NotEnoughUSDT();
        }
        fishcakeCoin.burn(msg.sender, _amount);
        USDT.safeTransfer(msg.sender, USDTAmount);

        emit ClaimSuccess(msg.sender, USDTAmount, _amount);
    }

    function balance() public view returns (uint256) {
        return USDT.balanceOf(address(this));
    }

    function calculateUSDT(uint256 amount) external view returns (uint256) {
        return _calculateUSDT(amount);
    }

    function _calculateUSDT(uint256 _amount) private view returns (uint256) {
        // USDT balance / fishcakeCoin total supply
        return balance() * _amount * ONE_USDT / (ONE_FCC * fishcakeCoin.totalSupply());
    }
}
