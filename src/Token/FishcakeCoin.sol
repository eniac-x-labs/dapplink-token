// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.24;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract FishcakeCoin is ERC20, Ownable {
    uint256 public constant MAX_TOTAL_SUPPLY = 1_000_000_000 * 10 ** 18;
    uint256 public constant MINING_POOL_ALLOCATION = (MAX_TOTAL_SUPPLY * 3) / 10; // 30% of total supply
    uint256 public constant PUBLIC_SALE_POOL_ALLOCATION = (MAX_TOTAL_SUPPLY * 2) / 10; // 20% of total supply
    uint256 public constant INVESTOR_SALE_POOL_ALLOCATION = MAX_TOTAL_SUPPLY / 10; // 10% of total supply
    uint256 public constant NFT_SALES_REWARDS_POOL_ALLOCATION = (MAX_TOTAL_SUPPLY * 2) / 10; // 20% of total supply
    uint256 public constant AIRDROP_POOL_ALLOCATION = MAX_TOTAL_SUPPLY / 10; // 10% of total supply
    uint256 public constant FUNDATION_POOL_ALLOCATION = MAX_TOTAL_SUPPLY / 10; // 10% of total supply
    address public miningPool;
    address public publicSalePool;
    address public investorSalePool;
    address public nftSalesRewardsPool;
    address public AirdropPool;
    address public foundationPool;
    address public redemptionPool;

    bool private MintingFinished = false;

    modifier onlyredemptionPool() {
        require(msg.sender == redemptionPool, "Only redemptionPool can call this function");
        _;
    }

    constructor() ERC20("Fishcake Coin", "FCC") Ownable(msg.sender) {}

    function setPoolAddress(
        address _miningPool,
        address _publicSalePool,
        address _investorSalePool,
        address _nftSalesRewardsPool,
        address _AirdropPool,
        address _foundationPool
    ) external onlyOwner {
        require(_miningPool != address(0), "MingingPool address is zero");
        require(_publicSalePool != address(0), "_publicSalePool address is zero");
        require(_investorSalePool != address(0), "_investorSalePool address is zero");
        require(_nftSalesRewardsPool != address(0), "_nftSalesRewardsPool address is zero");
        require(_AirdropPool != address(0), "_AirdropPool address is zero");
        require(_foundationPool != address(0), "_foundationPool address is zero");
        miningPool = _miningPool;
        publicSalePool = _publicSalePool;
        investorSalePool = _investorSalePool;
        nftSalesRewardsPool = _nftSalesRewardsPool;
        AirdropPool = _AirdropPool;
        foundationPool = _foundationPool;
    }

    function setredemptionPool(address _redemptionPool) external onlyOwner {
        require(_redemptionPool != address(0), "_redemptionPool can not be zero address");
        redemptionPool = _redemptionPool;
    }

    function PoolAllocation() external onlyOwner {
        require(MintingFinished == false, "Minting has been finished");
        require(miningPool != address(0), "Missing allocate miningPool address");
        require(publicSalePool != address(0), "Missing allocate publicSalePool address");
        require(investorSalePool != address(0), "Missing allocate investorSalePool address");
        require(nftSalesRewardsPool != address(0), "Missing allocate nftSalesRewardsPool address");
        require(AirdropPool != address(0), "Missing allocate AirdropPool address");
        require(foundationPool != address(0), "Missing allocate foundationPool address");
        _mint(miningPool, MINING_POOL_ALLOCATION);
        _mint(publicSalePool, PUBLIC_SALE_POOL_ALLOCATION);
        _mint(investorSalePool, INVESTOR_SALE_POOL_ALLOCATION);
        _mint(nftSalesRewardsPool, NFT_SALES_REWARDS_POOL_ALLOCATION);
        _mint(AirdropPool, AIRDROP_POOL_ALLOCATION);
        _mint(foundationPool, FUNDATION_POOL_ALLOCATION);
        MintingFinished = true;
    }

    function burn(address user, uint256 _amount) external onlyredemptionPool {
        _burn(user, _amount);
    }
}
