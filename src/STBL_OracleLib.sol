// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./STBL_Structs.sol";

import "./ISTBL_PT1_AssetOracle.sol";

/**
 * @title Oracle Library Functions
 * @notice Library providing utility functions for asset oracle price calculations
 * @dev Contains functions for forward and inverse price calculations using oracle data
 */
library STBL_OracleLib {
    /**
     * @notice Fetches and calculates forward price from oracle contract
     * @dev Multiplies oracle price by amount and adjusts for price decimals
     * @param oracle The oracle contract implementing iSTBL_AssetOracle interface
     * @param amount The amount to calculate price for (in token units)
     * @return forwardPrice Calculated forward price adjusted for oracle decimals
     */
    function fetchForwardPrice(
        iSTBL_PT1_AssetOracle oracle,
        uint256 amount
    ) internal view returns (uint256 forwardPrice) {
        forwardPrice = ((oracle.fetchPrice() * amount) /
            (10 ** oracle.getPriceDecimals()));
    }

    /**
     * @notice Fetches and calculates inverse price from oracle contract
     * @dev Divides amount by oracle price and adjusts for price decimals
     * @param oracle The oracle contract implementing iSTBL_AssetOracle interface
     * @param amount The amount to calculate inverse price for (in token units)
     * @return inversePrice Calculated inverse price adjusted for oracle decimals
     */
    function fetchInversePrice(
        iSTBL_PT1_AssetOracle oracle,
        uint256 amount
    ) internal view returns (uint256 inversePrice) {
        inversePrice =
            (amount * (10 ** oracle.getPriceDecimals())) /
            oracle.fetchPrice();
    }
}