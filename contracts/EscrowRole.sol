pragma solidity ^0.5.5;

import "@openzeppelin/contracts/GSN/Context.sol";
import "@openzeppelin/contracts/access/Roles.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";


contract EscrowRole is Context, Ownable {
  using Roles for Roles.Role;

  event EscrowRoleAdded(address indexed account);
  event EscrowRoleRemoved(address indexed account);

  Roles.Role private _escrows;

  modifier onlyEscrow() {
    require(isEscrow(_msgSender()), "EscrowRole: caller does not have the Escrow role");
    _;
  }

  function isEscrow(address account) public view returns (bool) {
    return _escrows.has(account);
  }

  function addEscrow(address account) public onlyOwner {
    _addEscrow(account);
  }

  function renounceEscrow() public {
    _removeEscrow(_msgSender());
  }

  function _addEscrow(address account) internal {
    _escrows.add(account);
    emit EscrowRoleAdded(account);
  }

  function _removeEscrow(address account) internal {
    _escrows.remove(account);
    emit EscrowRoleRemoved(account);
  }
}
