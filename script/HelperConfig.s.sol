//Deploy mocks on local chain
//Keep track of contract addresses on local chains
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    //If we are on local chain, we deploy mocks
    //Otherwise, we use the real contracts
    NetworkConifg public activeNetworkConfig;
    uint8 public constant decimals = 8;
    int256 public constant initialAnswer = 2000e8;
    struct NetworkConifg {
        address priceFeed; //eth/usd price feed address
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConifg memory) {
        return NetworkConifg(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    function getAnvilEthConfig() public returns (NetworkConifg memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
        //deploy the mocks
        //return the mock address
        vm.startBroadcast();
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(
            decimals,
            initialAnswer
        );
        vm.stopBroadcast();

        NetworkConifg memory config = NetworkConifg(address(mockV3Aggregator));
        return config;
    }
}
