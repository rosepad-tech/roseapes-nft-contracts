// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RoseApe721 is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    string private _name;
    string private _symbol;
    uint256 public _maxSupply = 5555;
    uint256 private _totalSupply;
    
    uint256 public _whiteListSalePrice = 100; // change later.
    uint256 public _publicSalePrice = 150; // change later.

    uint256 public _whiteListMaxAllAtOnce = 3;
    uint256 public _publicMaxAllAtOnce = 5;

    uint256 public _testPrice = 1; // for testing purposes only

    bool public paused = false;
    bool public testMode = false;

    address public devTeam = 0x93471f86C53926B07d4554D9f186f71F283fCD24;
    string public baseURI = "ipfs://QmfJ9LuJ7YvsyHW5UR7WSpT3Tbr3z6VZicSrJLzW1kk5YY/";
    bool public revealed = false;

    mapping(address => bool) public whiteListed;

    constructor(string memory name_ , string memory symbol_ ) ERC721(name_, symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    //  Public Mint
    function mint() public payable virtual {

        uint256 allAtOnceDefault = 1;
        require(!paused);
        require(msg.value >= 0, "Not enough ROSE sent; check price!");
        require(_tokenIdCounter.current() < _maxSupply);

        if(!testMode) {
            if (msg.sender != owner()) {
                if (whiteListed[msg.sender] != true) {
                    require(msg.value >= _whiteListSalePrice, "WL User: Not enough ROSE sent; check price!");
                    allAtOnceDefault = _whiteListMaxAllAtOnce;
                } else {
                    require(msg.value >= _publicSalePrice, "Not enough ROSE sent; check price!");
                    allAtOnceDefault = _publicMaxAllAtOnce;
                }
            }
        }

        for (uint256 i = 1; i <= allAtOnceDefault; i++) {
            _tokenIdCounter.increment();
            uint256 tokenId = _tokenIdCounter.current();
            _mint(msg.sender, tokenId);
        }
    }

    //  SafeMint for Dev Team
    function safeMint(address to) public onlyOwner {
        require(_tokenIdCounter.current() < _maxSupply);

        // increment
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(to, tokenId + 1);
    }

    //  Set the TOKEN URI
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI_ = _baseURI();

        if (revealed) {
            return bytes(baseURI_).length > 0 ? string(abi.encodePacked(baseURI_, Strings.toString(tokenId), ".json")) : "";
        } else {
            return string(abi.encodePacked(baseURI_, "hidden.json"));
        }
    }

    //  Withdraw Rose
    function withdraw() payable public onlyOwner {
        payable(devTeam).transfer(address(this).balance);
    }

    //  Configuration changes
    function changeBaseURI(string memory baseURI_) public onlyOwner {
        baseURI = baseURI_;
    }

    function changeWhiteListSalePrice(uint256 whiteListSalePrice_) public onlyOwner {
        _whiteListSalePrice = whiteListSalePrice_;
    }

    function changePublicSalePrice(uint256 publicSalePrice_) public onlyOwner {
        _publicSalePrice = publicSalePrice_;
    }


    function changePublicAllAtOnce(uint256 publicAllAtOnce_) public onlyOwner {
        _publicMaxAllAtOnce = publicAllAtOnce_;
    }

    function changeWhiteListAllAtOnce(uint256 publicAllAtOnce_) public onlyOwner {
        _whiteListMaxAllAtOnce = publicAllAtOnce_;
    }

    function changeDevTeam(address devTeam_) public onlyOwner {
        devTeam = devTeam_;
    }

    function changeRevealed(bool _revealed) public onlyOwner {
        revealed = _revealed;
    }

    function pause(bool _state) public onlyOwner {
        paused = _state;
    }

    function setToTestMode(bool _testMode) public onlyOwner {
        testMode = _testMode;
    }

    function whitelistUser(address _user) public onlyOwner {
        whiteListed[_user] = true;
    }

    function removeWhitelistUser(address _user) public onlyOwner {
        whiteListed[_user] = false;
    }

}