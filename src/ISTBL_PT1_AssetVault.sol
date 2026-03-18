// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./STBL_Structs.sol";

/**
 * @title Asset Vault Interface
 * @notice Manages the secure storage and handling of assets in the Pi Protocol
 * @dev Implements access control for asset custody and yield distribution
 */
interface iSTBL_PT1_AssetVault {
    /**
     * @notice Emitted when tokens are deposited into the vault
     * @param _token Address of the ERC20 token being deposited
     * @param _from Address sending the tokens into the vault
     * @param _depositValue Total amount of tokens deposited
     * @param _depositFee Fee charged on the deposit transaction
     * @param _hairCut Percentage reduction applied to deposit value
     * @param _insuranceFee Additional fee for insurance protection
     * @param _depositFeesAssetValue Asset value of the deposit fee amount
     * @param _insuranceFeeAssetValue Asset value of the insurance fee amount
     */
    event depositEvent(
        address _token,
        address _from,
        uint256 _depositValue,
        uint256 _depositFee,
        uint256 _insuranceFee,
        uint256 _hairCut,
        uint256 _depositFeesAssetValue,
        uint256 _insuranceFeeAssetValue
    );

    /**
     * @notice Emitted when tokens are withdrawn from the vault
     * @param _token Address of the ERC20 token being withdrawn
     * @param _to Address receiving the tokens from the vault
     * @param _netValue Net amount of tokens withdrawn after fees and haircuts
     * @param _withdrawFee Fee charged on the withdrawal transaction
     * @param _withdrawFeeAssetValue Asset value of the withdrawal fee amount
     * @param _hairCut Percentage reduction applied to withdrawal value
     */
    event withdrawEvent(
        address _token,
        address _to,
        uint256 _netValue,
        uint256 _withdrawFee,
        uint256 _withdrawFeeAssetValue,
        uint256 _hairCut
    );

    /**
     * @notice Emitted when yield is distributed to participants
     * @param token Address of the ERC20 token for which yield is distributed
     * @param distributor Address that initiated the yield distribution
     * @param netYield Net amount of yield distributed to participants
     * @param yieldFee Fee charged on the yield distribution
     * @param yieldValue Total gross yield value before fees
     */
    event YieldDistributed(
        address indexed token,
        address indexed distributor,
        uint256 netYield,
        uint256 yieldFee,
        uint256 yieldValue
    );

    /**
     * @notice Event emitted when deposit, withdrawal, yield, and insurance fees are withdrawn to treasury
     * @param treasury Address where token fees are withdrawn
     * @param depositFees Total amount of deposit fees withdrawn
     * @param withdrawFees Total amount of withdrawal fees withdrawn
     * @param yieldFees Total amount of yield fees withdrawn
     * @param insuranceFees Total amount of insurance fees withdrawn
     * @param Fees Total Fees priced in asset value
     */
    event FeesWithdrawn(
        address indexed treasury,
        uint256 depositFees,
        uint256 withdrawFees,
        uint256 yieldFees,
        uint256 insuranceFees,
        uint256 Fees
    );

    /**
     * @notice Emitted when emergency funds are withdrawn from the vault
     * @param _amt Amount of funds withdrawn during the emergency procedure
     */
    event EmergencyFundsWithdraw(uint256 _amt);

    /**
     * @notice Emitted when the contract implementation is upgraded
     * @dev Triggered during an upgrade of the contract to a new implementation
     * @param newImplementation Address of the new implementation contract
     */
    event ContractUpgraded(address newImplementation);

    /**
     * @notice Handles secure ERC20 token deposits into the asset vault
     * @dev Validates and processes token deposits with metadata containing fee and haircut information
     * @param _from Address initiating the token deposit
     * @param MetaData Structured data containing deposit value, fees, haircuts and other token metadata
     */
    function depositERC20(address _from, YLD_Metadata memory MetaData) external;

    /**
     * @notice Handles ERC20 token withdrawals from the vault
     * @dev Only callable by the valid issuer
     * @param _to Address to receive the tokens
     * @param MetaData Structured data containing withdrawal details including value, fees, and haircuts
     */
    function withdrawERC20(address _to, YLD_Metadata memory MetaData) external;

    /**
     * @notice Distributes accumulated yield to vault participants
     * @dev Calculates and distributes yield based on predefined protocols
     */
    function distributeYield() external;

    /**
     * @notice Calculates the price differentiation for the asset
     * @dev Computes the price variance or spread for the asset under management
     * @return The calculated price differentiation metric
     */
    function CalculatePriceDifferentiation() external view returns (uint256);

    /**
     * @notice Withdraws accumulated protocol fees to the treasury
     * @dev Transfers accumulated fees from deposit, withdrawal, and other sources
     */
    function withdrawFees() external;

    /**
     * @notice Drains a specified amount of tokens from the vault to treasury during emergency situations
     * @dev Emergency function that transfers tokens directly to treasury when asset is disabled
     * @dev Can only be executed when the asset status is not ENABLED for security purposes
     * @dev Reduces the net asset deposit tracking by the withdrawn amount
     * @custom:event EmergencyFundsWithdraw Emitted with the amount of tokens withdrawn
     * @custom:security Only callable when asset is disabled and treasury address is valid
     */
    function emergencyWithdraw() external;

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

    /**
     * @notice Retrieves the complete vault state data
     * @dev Returns all vault metrics including deposits, fees, yields, and tracking values
     * @return VaultStruct containing comprehensive vault state information
     */
    function fetchVaultData() external view returns (VaultStruct memory);
}