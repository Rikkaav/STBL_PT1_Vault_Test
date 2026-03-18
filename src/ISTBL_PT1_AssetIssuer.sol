// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./STBL_Structs.sol";

/**
 * @title STBL Asset Issuer Interface
 * @notice Interface for handling the issuance and redemption of stable assets in the Pi Protocol
 * @dev Acts as an intermediary between users and the protocol's core components for asset management
 */
interface iSTBL_PT1_AssetIssuer {
    /**
     * @notice Emitted when an asset is deposited into the protocol
     * @dev Contains detailed information about the deposit transaction and minted NFT
     * @param user Address of the user making the deposit
     * @param _tokenID Unique identifier of the NFT minted to represent the deposited asset
     * @param _MetaData Metadata structure containing comprehensive details about the deposited asset
     */
    event depositAsset(
        address indexed user,
        uint256 _tokenID,
        YLD_Metadata _MetaData
    );

    /**
     * @notice Emitted when an asset is withdrawn from the protocol
     * @dev Triggered when a user burns their NFT to withdraw the underlying asset
     * @param user Address of the user withdrawing the asset
     * @param _tokenID ID of the NFT being burned during the withdrawal process
     * @param _MetaData Metadata structure containing details about the withdrawn asset
     */
    event withdrawAsset(
        address indexed user,
        uint256 _tokenID,
        YLD_Metadata _MetaData
    );

    /**
     * @notice Emitted when an asset is withdrawn from the protocol treasury
     * @dev Used for administrative or treasury-related asset withdrawals
     * @param user Address of the user or admin withdrawing the asset from treasury
     * @param _tokenID ID of the NFT burned during the treasury withdrawal operation
     * @param _MetaData Metadata structure containing comprehensive details about the withdrawn asset
     */
    event withdrawAssetTreasury(
        address indexed user,
        uint256 _tokenID,
        YLD_Metadata _MetaData
    );

    /**
     * @notice Emitted when the contract implementation is upgraded
     * @dev Triggered during an upgrade of the contract to a new implementation
     * @param newImplementation Address of the new implementation contract
     */
    event ContractUpgraded(address newImplementation);

    /**
     * @notice Deposits real-world assets and mints a yield-bearing NFT to the caller
     * @dev Wrapper function that calls iDeposit with the message sender as the recipient
     * @param assetValue Amount of assets to deposit, specified in the asset's native decimal precision
     * @return nftID The unique identifier of the minted NFT that represents ownership of the deposited assets
     */
    function deposit(uint256 assetValue) external returns (uint256);

    /**
     * @notice Deposits real-world assets and mints a yield-bearing NFT to a specified sender
     * @dev Wrapper function that calls iDeposit with a custom sender address
     * @param assetValue Amount of assets to deposit, specified in the asset's native decimal precision
     * @param _sender The address that will receive the ownership NFT
     * @return nftID The unique identifier of the minted NFT that represents ownership of the deposited assets
     */
    function deposit(
        uint256 assetValue,
        address _sender
    ) external returns (uint256);

    /**
     * @notice Withdraws deposited assets by burning the caller's yield-bearing NFT
     * @dev Wrapper function that calls iWithdraw with the message sender as the owner
     * @param _tokenID The unique identifier of the NFT to burn in exchange for withdrawing the underlying assets
     */
    function withdraw(uint256 _tokenID) external;

    /**
     * @notice Withdraws deposited assets by burning a specified sender's yield-bearing NFT
     * @dev Wrapper function that calls iWithdraw with a custom sender address
     * @param _tokenID The unique identifier of the NFT to burn in exchange for withdrawing the underlying assets
     * @param _sender The address of the account withdrawing assets
     */
    function withdraw(uint256 _tokenID, address _sender) external;

    /**
     * @notice Enables yield generation for a specific NFT
     * @dev Activates staking for an NFT in the yield distribution system to start earning rewards
     * @param _tokenID The unique identifier of the NFT to enable yield generation for
     * @custom:security Requires SPLITTER_ROLE for access control
     */
    function enableYield(uint256 _tokenID) external;

    /**
     * @notice Disables yield generation for a specific NFT
     * @dev Deactivates staking for an NFT in the yield distribution system to stop earning rewards
     * @param _tokenID The unique identifier of the NFT to disable yield generation for
     * @custom:security Requires SPLITTER_ROLE for access control
     */
    function disableYield(uint256 _tokenID) external;

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