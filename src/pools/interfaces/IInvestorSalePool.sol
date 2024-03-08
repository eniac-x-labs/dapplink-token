// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.24;

interface IInvestorSalePool {
    enum InvestorLevel {
        One,
        Two,
        Three,
        Four
    }

    event BuyFishcakeCoinSuccess(
        address indexed buyer, InvestorLevel level, uint256 USDTAmount, uint256 fishcakeCoinAmount
    );

    error NotEnoughFishcakeCoin();
    error AmountLessThanMinimum();
    error InvestorLevelError();

    function Buy(uint256 _amount) external;

    function BuyWithUSDT(uint256 _amount) external;

    function QueryLevelWithUSDT(uint256 _amount) external view returns (InvestorLevel);

    function QueryLevelWithFCC(uint256 _amount) external view returns (InvestorLevel);

    function calculateFCC(InvestorLevel level, uint256 _amount) external pure returns (uint256);

    function calculateUSDT(InvestorLevel level, uint256 _amount) external pure returns (uint256);

    function setValut(address _valut) external;

    function withdrawUSDT(uint256 _amount) external;
}
