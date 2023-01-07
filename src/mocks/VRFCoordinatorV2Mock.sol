// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// importing VRF mock contract from chainlink library
import "chainlink/mocks/VRFCoordinatorV2Mock.sol";

contract MockVRFCoordinatorV2 is VRFCoordinatorV2Mock {
    uint96 constant MOCK_BASE_FEE = 100000000000000000;
    uint96 constant MOCK_GAS_PRICE_LINK = 1e9;

    constructor() VRFCoordinatorV2Mock(MOCK_BASE_FEE, MOCK_GAS_PRICE_LINK) {}
}
