// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol"; // To use the Strings library

contract SVG_NFT is ERC721, Ownable {
    using Strings for uint256; // To convert uint256 to string
    uint256 public constant MAX_SUPPLY = 800; // Maximum of 1000 NFTs
    uint256 public constant MINT_PRICE = 1 ether; // Cost to mint 1 NFT is 1 unit of native token (1 ETH in this case)
    mapping(address => bool) private ownsNFT; // Checks if wallet owns an NFT
    uint256 public currentTokenId; // This tracks the total number of minted NFTs

    // Constructor now includes the owner address
    constructor() ERC721("800", "A bad NFT on a pretty good L1") Ownable(msg.sender) {}

    function mint() public payable  {
        require(currentTokenId < MAX_SUPPLY, "Max supply reached");
        require(!ownsNFT[msg.sender], "Wallet already owns an NFT"); // Check if address owns an NFT
        require(msg.value == MINT_PRICE, "Incorrect mint price");
        // require(_walletMintCount[to] == 0, "Wallet already owns an NFT");
        require(msg.value == MINT_PRICE, "Incorrect mint price");
        currentTokenId++;
        _mint(msg.sender, currentTokenId);
        ownsNFT[msg.sender] = true; // Mark this wallet as owning an NFT
    }

    function tokenURI(uint256 tokenId) public pure override returns (string memory) {

        string memory svg = generateSVG(tokenId);
        string memory image = string(abi.encodePacked("data:image/svg+xml;base64,", Base64.encode(bytes(svg))));

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "SVG NFT #', 
                        tokenId.toString(),  // Convert tokenId to string using the Strings library
                        '", "description": "An on-chain SVG NFT", "image": "', 
                        image, 
                        '"}'
                    )
                )
            )
        );

        return string(abi.encodePacked("data:application/json;base64,", json));
    }

function generateSVG(uint256 tokenId) internal pure returns (string memory) {
    // Simple SVG design with text
    string memory svg = string(
        abi.encodePacked(
            "<svg xmlns='http://www.w3.org/2000/svg' height='500' width='500'>",
            "<rect width='100%' height='100%' fill='#000000'/>",  // Black background
            "<text x='50%' y='30%' dominant-baseline='middle' text-anchor='middle' fill='#00FFFF' font-size='36' font-family='Arial'>",
            "Hyperliquid",  // Heading text
            "</text>",
            "<text x='50%' y='50%' dominant-baseline='middle' text-anchor='middle' fill='#FFFFFF' font-size='16' font-family='Arial'>",
            "too busy coding for PFPs",  // Subheading text
            "</text>",
            "<text x='50%' y='70%' dominant-baseline='middle' text-anchor='middle' fill='#FFFFFF' font-size='12' font-family='Arial'>",
            "NFT #", tokenId.toString(),  // Display token ID at the bottom
            "</text>",
            "</svg>"
        )
    );

    return svg;
}

        // Function to allow the owner to withdraw the collected funds
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        payable(owner()).transfer(balance);
    }

    // Function to accept Ether transfers directly to the contract
    receive() external payable {
    // The contract can receive Ether, and the Ether will be stored in its balance.
}

}

