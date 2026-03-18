// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title DecimalConverter
 * @dev Library for converting token amounts between different decimal representations
 * @notice Provides utility functions for handling decimal conversions between ERC20 tokens
 * @author Smart Contract Developer
 */
library DecimalConverter {
    /**
     * @dev Convert token amount from source decimal to target decimal
     * @notice Converts token amounts between different decimal precisions without overflow protection
     * @param amount The token amount to convert
     * @param sourceDecimals Decimal places of the source token (e.g., 6 for USDC)
     * @param targetDecimals Decimal places of the target token (e.g., 18 for ETH)
     * @return convertedAmount Converted token amount in target decimal precision
     */
    function convertDecimals(
        uint256 amount,
        uint8 sourceDecimals,
        uint8 targetDecimals
    ) internal pure returns (uint256 convertedAmount) {
        // If decimals are the same, return original amount
        if (sourceDecimals == targetDecimals) {
            return amount;
        }

        // Handle conversion based on decimal difference
        if (sourceDecimals > targetDecimals) {
            // Reduce precision
            uint256 decimalDifference = sourceDecimals - targetDecimals;
            return amount / (10 ** decimalDifference);
        } else {
            // Increase precision
            uint256 decimalDifference = targetDecimals - sourceDecimals;
            return amount * (10 ** decimalDifference);
        }
    }

    /**
     * @dev Safely convert token amount with overflow protection
     * @notice Converts token amounts between different decimal precisions with overflow protection
     * @param amount The token amount to convert
     * @param sourceDecimals Decimal places of the source token (e.g., 6 for USDC)
     * @param targetDecimals Decimal places of the target token (e.g., 18 for ETH)
     * @return convertedAmount Converted token amount in target decimal precision
     * @custom:reverts "Decimal conversion would cause overflow" if multiplication would overflow uint256
     */
    function safeConvertDecimals(
        uint256 amount,
        uint8 sourceDecimals,
        uint8 targetDecimals
    ) internal pure returns (uint256 convertedAmount) {
        // If decimals are the same, return original amount
        if (sourceDecimals == targetDecimals) {
            return amount;
        }

        // Handle conversion based on decimal difference
        if (sourceDecimals > targetDecimals) {
            // Reduce precision
            uint256 decimalDifference = sourceDecimals - targetDecimals;
            return amount / (10 ** decimalDifference);
        } else {
            // Increase precision with overflow check
            uint256 decimalDifference = targetDecimals - sourceDecimals;

            // Check for potential overflow
            if (amount > type(uint256).max / (10 ** decimalDifference)) {
                revert("Decimal conversion would cause overflow");
            }

            return amount * (10 ** decimalDifference);
        }
    }

    /**
     * @dev Get normalized amount based on standard 18 decimals
     * @notice Converts any token amount to 18 decimal precision for standardized calculations
     * @param amount Token amount to normalize in its native decimal precision
     * @param tokenDecimals Decimal places of the token (e.g., 6 for USDC, 8 for WBTC)
     * @return normalizedAmount Normalized amount in 18 decimal precision
     */
    function normalizeToDecimals18(
        uint256 amount,
        uint8 tokenDecimals
    ) internal pure returns (uint256 normalizedAmount) {
        return convertDecimals(amount, tokenDecimals, 18);
    }

    /**
     * @dev Convert 18 decimal amount to specific token decimals
     * @notice Converts standardized 18 decimal amounts back to token's native decimal precision
     * @param amount Amount in 18 decimal precision
     * @param tokenDecimals Target token decimal places (e.g., 6 for USDC, 8 for WBTC)
     * @return convertedAmount Converted amount in target token's native decimal precision
     */
    function convertFrom18Decimals(
        uint256 amount,
        uint8 tokenDecimals
    ) internal pure returns (uint256 convertedAmount) {
        return convertDecimals(amount, 18, tokenDecimals);
    }

    /**
     * @dev Get token's native decimal precision
     * @notice Retrieves the decimal precision of an ERC20 token via low-level call
     * @param tokenAddress Address of the ERC20 token contract
     * @return decimals Token's decimal places (defaults to 18 if call fails)
     */
    function getTokenDecimals(
        address tokenAddress
    ) internal view returns (uint8 decimals) {
        // Create minimal interface for decimals
        (bool success, bytes memory data) = tokenAddress.staticcall(
            abi.encodeWithSignature("decimals()")
        );

        // Return 18 as default if call fails
        if (!success || data.length == 0) {
            return 18;
        }

        return abi.decode(data, (uint8));
    }
}