pragma solidity ^0.5.5;

library Users {
  struct User {
    string passportNumber;
  }

  function comparePassportNumbers(
    string memory _passportNumber1,
    string memory _passportNumber2
  ) internal returns (bool) {
    return keccak256(abi.encodePacked((
      _passportNumber1
    ))) == keccak256(abi.encodePacked((
      _passportNumber2
    )));
  }

  function searchByPassportNumber(
    User[] storage self,
    string memory value
  ) internal returns (bool) {
    for (uint i = 0; i < self.length; i++) {
      if (comparePassportNumbers(self[i].passportNumber, value)) {
        return true;
      }
    }
    return false;
  }
}
