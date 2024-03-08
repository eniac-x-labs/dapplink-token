// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.24;

interface IAirdropPool {
    event Initialize(address rewardToken, bytes32 merkleRoot, uint256 deadline);
    event Claim(address indexed user, uint256 index, uint256 amount);
    event Refund(uint256 amount);
    event UpdateMerkleRoot(bytes32 newMerkleRoot);

    function claim(uint256 index, uint256 amount, bytes32[] calldata merkleProof) external returns (bool flag);

    function refund() external returns (uint256 amount);

    function updateMerkleRoot(bytes32 newMerkleRoot) external;
}
