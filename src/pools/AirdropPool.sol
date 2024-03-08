// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.24;

import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {FishcakeCoin} from "../Token/FishcakeCoin.sol";
import {IAirdropPool} from "./interfaces/IAirdropPool.sol";

contract AirdropsPool is IAirdropPool, ReentrancyGuard, Ownable {
    using SafeERC20 for IERC20;

    IERC20 public immutable rewardToken;
    uint256 public immutable deadline;

    bytes32 public merkleRoot;
    mapping(uint256 => bool) public claimed;

    constructor(IERC20 _rewardToken, bytes32 _merkleRoot, uint256 _deadline) Ownable(msg.sender) {
        rewardToken = _rewardToken;
        merkleRoot = _merkleRoot;
        deadline = _deadline;

        emit Initialize(address(_rewardToken), _merkleRoot, _deadline);
    }

    function claim(uint256 index, uint256 amount, bytes32[] calldata merkleProof)
        external
        nonReentrant
        returns (bool flag)
    {
        require(block.timestamp <= deadline, "only before deadline");
        require(!claimed[index], "already claimed");

        claimed[index] = true;

        flag = _claimRewards(msg.sender, index, amount, merkleProof);
        require(flag, "wrong Merkle proof");

        emit Claim(msg.sender, index, amount);
    }

    function refund() external nonReentrant onlyOwner returns (uint256 amount) {
        require(block.timestamp > deadline, "only after deadline");

        amount = rewardToken.balanceOf(address(this));
        rewardToken.safeTransfer(owner(), amount);

        emit Refund(amount);
    }

    function updateMerkleRoot(bytes32 newMerkleRoot) external onlyOwner {
        merkleRoot = newMerkleRoot;
        emit UpdateMerkleRoot(newMerkleRoot);
    }

    function _claimRewards(address user, uint256 index, uint256 amount, bytes32[] calldata merkleProof)
        private
        view
        returns (bool flag)
    {
        bytes32 leaf = keccak256(abi.encodePacked(index, user, amount));
        flag = MerkleProof.verify(merkleProof, merkleRoot, leaf);
    }
}
