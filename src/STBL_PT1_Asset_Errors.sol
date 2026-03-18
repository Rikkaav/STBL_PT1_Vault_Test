// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @notice Thrown when the asset setup is not complete or inactive
 * @param id The ID of the asset that is not properly setup
 */
error STBL_Asset_SetupNotComplete(uint256 id);

/**
 * @notice Thrown when an unauthorized issuer attempts an operation
 * @dev Used in the isValidIssuer modifier to restrict access
 * @param id The ID of the asset with the invalid issuer
 */
error STBL_Asset_InvalidIssuer(uint256 id);

/**
 * @notice Thrown when the calling address is not the valid vault contract
 * @param id The ID of the asset with the invalid vault address
 */
error STBL_Asset_InvalidVault(uint256 id);

/**
 * @notice Thrown when attempting to interact with an invalid asset
 * @param id The ID of the invalid asset
 */
error STBL_Asset_InvalidAsset(uint256 id);

/**
 * @notice Thrown when the provided owner does not match the expected owner
 * @param _tokenID The token ID for which withdrawal was attempted too early
 * @param owner The owner ID that was provided but is incorrect
 */
error STBL_Asset_IncorrectOwner(uint256 _tokenID, address owner);

/**
 * @notice Thrown when attempting to call a function before contract initialization
 * @param id The ID of the uninitialized asset
 */
error STBL_Asset_NotInitialized(uint256 id);

/**
 * @notice Thrown when attempting to initialize an already initialized asset
 * @param id The ID of the asset that is already initialized
 */
error STBL_Asset_Initialized(uint256 id);

/**
 * @notice Thrown when attempting to withdraw before the required duration has passed
 * @param id The ID of the asset where early withdrawal was attempted
 * @param _tokenID The token ID for which withdrawal was attempted too early
 */
error STBL_Asset_WithdrawDurationNotReached(uint256 id, uint256 _tokenID);

/**
 * @notice Thrown when attempting to claim yield before the required duration has passed
 * @param id The ID of the asset where early yield claim was attempted
 * @param duration The required duration that must be satisfied before claiming yield
 */
error STBL_Asset_YieldDurationNotReached(uint256 id, uint256 duration);

/**
 * @notice Thrown when the vault value is insufficient compared to the asset value
 * @param _assetValue The current asset value that is being compared
 * @param _usdValue The USD value that is insufficient for the operation
 */
error STBL_Asset_InsufficientVaultValue(uint256 _assetValue, uint256 _usdValue);

/**
 * @notice Thrown when an invalid deposit amount is provided
 * @param assetID The ID of the asset for which the invalid deposit was attempted
 * @param amount The invalid deposit amount that was provided
 */
error STBL_Asset_InvalidDepositAmount(uint256 assetID, uint256 amount);
/**
 * @notice Thrown when the oracle price is stale or outdated
 * @param price The stale price value returned by the oracle
 * @param time The timestamp when the stale price was last updated
 */
error STBL_Asset_OracleStalePrice(uint256 price, uint256 time);

/**
 * @notice Thrown when the oracle is disabled or not available
 */
error STBL_Asset_OracleDisabled();