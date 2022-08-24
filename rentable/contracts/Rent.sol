// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "./ERC4907.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Rent is ERC4907, Ownable {
  
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;
  
  constructor() ERC4907("RentableNft","CRT") {
  }

  function mint(string memory _tokenURI) public onlyOwner {
    _tokenIds.increment(); //incrementa el token cada vez que se mintea
    uint256 newTokenId = _tokenIds.current();
    _safeMint(msg.sender, newTokenId);
    _setTokenURI(newTokenId, _tokenURI);

  }

  function burn(uint256 tokenId)public {
    _burn(tokenId);
  }
}
