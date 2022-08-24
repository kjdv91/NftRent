// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.9.0;

import "./IERC4907.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract ERC4907 is ERC721URIStorage, IERC4907 {
  struct UserInfo{
    address user;
    uint64 expire;
  }

  mapping(uint256 => UserInfo)internal _users;  //mapping de la estructura para ver info

  constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol){

  }

  //virtual se puede anular la funcion y sobreescribir una vez heradado este contratos
  //override anula la funcion setUser de la interfaz

  function setUser(uint256 tokenId, address user, uint64 expires) public virtual override{
    require(
      //Devuelve si operator tiene permiso para administrar todos los activos de owner.
      _isApprovedOrOwner(msg.sender, tokenId),
      "ERC721: transfer caller is not owner nor approved"
    );
    
    
    UserInfo storage info = _users[tokenId]; //mapping
    info.user = user; //seteo el usuario pasado como parametro en la funcion setUser
    info.expire = expires; //seteo la expiracion del arrendimiento del nft
    emit UpdateUser(tokenId, user, expires);


  }
  //fecha de vencimiento
  function userOf(uint256 tokenId) public view virtual returns(address)
  {
    if((_users[tokenId].expire >=block.timestamp)) //mapping verifica la fecha de expiracion
    {
      return _users[tokenId].user; //me retorna la info del user

    }else{
      return address(0);

    }

  }
  //espiracion del arrendamiento del contrato  devolvera la fecha de caducidad 
  function userExpires(uint256 tokenId) public virtual override view returns(uint256){
    return _users[tokenId].expire;

  }

  //verificar que es un standar erc4907 interfaz y 
  //Interfaz de soporte
  //interfaceId sabe si nuestro nft es erc4907
  /// @dev See {IERC165-supportsInterface}.
  function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override
    returns (bool)
  {
    return
      interfaceId == type(IERC4907).interfaceId ||
      super.supportsInterface(interfaceId);
  }

  //evento cada vez que cambia de usuario el nft se hace transferencia funcion transfer
  //funcion interna solo puede ser llamada dentro del contratp
  //_beforeTokenTransfer se anula de ERC721 heradado
  function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override{
    super._beforeTokenTransfer(from, to, tokenId);
    //me aseguro que estoy transfieriendo el nft a otra persona
    if(from != to && _users[tokenId].user !=address(0)){
      delete _users[tokenId]; //elimina la informacion anterior alquiler
      //emite un evento y devuelve los nuevos datos
      emit UpdateUser(tokenId, address(0), 0);
    }
  }

}
