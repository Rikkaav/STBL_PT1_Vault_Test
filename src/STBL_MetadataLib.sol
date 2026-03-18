// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./STBL_Structs.sol";

/**
 * @title STBL_MetadataLib
 * @notice Library providing utility functions for YLD_Metadata struct
 */
library STBL_MetadataLib {
    /**
     * @notice Checks if a token metadata is valid
     * @param data The token metadata to validate
     * @return bool True if the token metadata is valid
     */
    function isValid(YLD_Metadata memory data) internal pure returns (bool) {
        return data.assetID != 0 && data.isDisabled == false;
    }

    /**
     * @notice Calculates and updates all fee amounts based on the gross stable value
     * @param data The YLD_Metadata struct containing fee rates and gross value
     * @return YLD_Metadata The updated metadata struct with calculated fee amounts
     */
    function calculateDepositFees(
        YLD_Metadata memory data
    ) internal pure returns (YLD_Metadata memory) {
        data.depositfeeAmount =
            (data.stableValueGross * data.Fees.depositFee) /
            FEES_CONSTANT; // Assuming fee is in basis points
        data.haircutAmount =
            (data.stableValueGross * data.Fees.hairCut) /
            FEES_CONSTANT; // Assuming fee is in basis points
        data.insurancefeeAmount =
            (data.stableValueGross * data.Fees.insuranceFee) /
            FEES_CONSTANT; // Assuming fee is in basis points
        data.withdrawfeeAmount =
            (data.stableValueGross * data.Fees.withdrawFee) /
            FEES_CONSTANT; // Assuming fee is in basis points

        return data;
    }
}