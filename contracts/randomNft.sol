// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CHIX is ERC721Enumerable, Ownable, VRFConsumerBaseV2 {
    enum char {
        name,
        experience,
        strength,
        durability,
        speed,
        color
    }

    // Goerli/chainlink vars for randommness based on network specifications
    // Chainlink VRF Variables
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    uint64 private immutable i_suscriptionId;
    bytes32 private immutable i_gasLane;
    uint32 private immutable i_callbackGasLimit;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;

    constructor(
        address vrfCoordinatorV2,
        uint64 suscriptionId,
        bytes32 gasLane,
        uint256 mintFee,
        uint32 callbackGasLimit,
        string[3333] memory nftTokenUris
    ) VRFConsumerBaseV2(vrfCoordinatorV2) ERC721("DigitalVistas", "DV") {}
}
