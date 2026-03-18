// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title STBL Asset Price Oracle Interface
 * @notice Interface for retrieving asset price information in the STBL protocol
 * @dev This interface defines the standard methods for price oracles used by the STBL system
 */
interface iSTBL_PT1_AssetOracle {
    /** @notice Emitted when the oracle is enabled
     */
    event oracleEnabled();

    /** @notice Emitted when the oracle is disabled
     */
    event oracleDisabled();

    /** @notice Emitted when the oracle decimals are set
     * @param _decimals The number of decimals set for price representation
     */
    event oracleSetDecimals(uint256 _decimals);

    /** @notice Emitted when the oracle price threshold is set
     * @param _threshold The price threshold that was set
     */
    event oracleSetPriceThreshold(uint256 _threshold);

    /** @notice Enables the oracle
     * @dev Only admin can call this function
     */
    function enableOracle() external;

    /** @notice Disables the oracle
     * @dev Only admin can call this function
     */
    function disableOracle() external;

    /** @notice Sets the number of decimals for price representation
     * @param _decimals The number of decimals to be used for price representation
     * @dev Only admin can call this function
     */
    function setPriceDecimals(uint256 _decimals) external;

    /** @notice Sets the price threshold
     * @param _threshold The price threshold to be set
     * @dev Only admin can call this function
     */
    function setPriceThreshold(uint256 _threshold) external;

    /** @notice Gets the number of decimals for the price
     * @return The number of decimals used for price representation (8 decimals)
     */
    function getPriceDecimals() external view returns (uint256);

    /** @notice Retrieves the current price of the USDY asset
     * @return price The current price of the USDY asset with 8 decimal precision
     * @dev Returns the stored price value for the USDY asset
     */
    function fetchPrice() external view returns (uint256);
}