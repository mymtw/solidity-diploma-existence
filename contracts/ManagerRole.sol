pragma solidity ^0.5.5;

import "@openzeppelin/contracts/GSN/Context.sol";
import "@openzeppelin/contracts/access/Roles.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";


contract ManagerRole is Context, Ownable {
  using Roles for Roles.Role;

  event ManagerRoleAdded(address indexed account);
  event ManagerRoleRemoved(address indexed account);

  Roles.Role private _managers;

  modifier onlyManager() {
    require(isManager(_msgSender()), "ManagerRole: caller does not have the Manager role");
    _;
  }

  function isManager(address account) public view returns (bool) {
    return _managers.has(account);
  }

  function addManagerRole(address account) public onlyOwner {
    _addManager(account);
  }

  function renounceManager() public {
    _removeManager(_msgSender());
  }

  function _addManager(address account) internal {
    _managers.add(account);
    emit ManagerRoleAdded(account);
  }

  function _removeManager(address account) internal {
    _managers.remove(account);
    emit ManagerRoleRemoved(account);
  }
}
