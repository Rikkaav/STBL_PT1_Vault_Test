// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./STBL_Structs.sol";

/**
 * @title STBL Asset Yield Distributor Interface
 * @notice Interface for managing reward distribution for staked assets in the STBL Protocol
 * @dev Defines the contract interface for reward calculation, distribution, and tracking for yield-bearing assets
 * @author STBL Protocol Team
 */
interface iSTBL_PT1_AssetYieldDistributor {
    /**
     * @notice Emitted when rewards are distributed to all stakers
     * @param amount The total amount of rewards distributed
     */
    event RewardDistributed(uint256 amount);

    /**
     * @notice Emitted when staking is enabled for a specific token
     * @param id The token ID for which staking is enabled
     * @param amount The amount being staked
     */
    event StakingEnabled(uint256 indexed id, uint256 amount);

    /**
     * @notice Emitted when staking is disabled for a specific token
     * @param id The token ID for which staking is disabled
     * @param amount The amount being unstaked
     */
    event StakingDisabled(uint256 indexed id, uint256 amount);

    /**
     * @notice Emitted when rewards are claimed by a token holder
     * @param tokenId The token ID for which rewards are claimed
     * @param amount The amount of rewards claimed
     */
    event RewardClaimed(uint256 indexed tokenId, uint256 amount);

    /**
     * @notice Emitted when the contract implementation is upgraded
     * @dev Triggered during an upgrade of the contract to a new implementation
     * @param newImplementation Address of the new implementation contract
     */
    event ContractUpgraded(address newImplementation);

    /**
     * @notice Distributes rewards proportionally to all active stakers
     * @param reward The total amount of rewards to distribute
     * @dev Can only be called by the authorized vault contract
     * @dev Updates the global reward per token accumulated value
     */
    function distributeReward(uint256 reward) external;

    /**
     * @notice Calculates the total unclaimed rewards for a specific token ID
     * @param id The token ID to calculate rewards for
     * @return The total amount of rewards earned but not yet claimed
     * @dev Returns 0 if the token is not currently staking or has no rewards
     */
    function calculateRewardsEarned(uint256 id) external view returns (uint256);

    /**
     * @notice Enables staking for a token ID with specified stake amount
     * @param id The token ID to enable staking for
     * @param value The amount to stake for this token
     * @dev Can only be called by the authorized issuer contract
     * @dev Updates the token's staking status and begins reward accumulation
     */
    function enableStaking(uint256 id, uint256 value) external;

    /**
     * @notice Disables staking for a token ID and unstakes specified amount
     * @param id The token ID to disable staking for
     * @param value The amount to unstake
     * @dev Can only be called by the authorized issuer contract
     * @dev Automatically claims any pending rewards before disabling
     */
    function disableStaking(uint256 id, uint256 value) external;

    /**
     * @notice Claims all accumulated rewards for a specific token ID
     * @param id The token ID to claim rewards for
     * @return The amount of rewards claimed and transferred
     * @dev Can only be called by the token owner or authorized operator
     * @dev Resets the reward counter for the token after claiming
     */
    function claim(uint256 id) external returns (uint256);

    /**
     * @notice Retrieves the asset ID managed by this vault instance
     * @dev Returns the unique identifier for the asset type this vault handles
     * @return The asset ID associated with this vault
     */
    function fetchAssetID() external view returns (uint256);

    /**
     * @notice Retrieves the protocol registry contract address
     * @dev Returns the registry contract that provides system configuration and access control
     * @return The address of the protocol registry contract
     */
    function fetchRegistry() external view returns (address);
}