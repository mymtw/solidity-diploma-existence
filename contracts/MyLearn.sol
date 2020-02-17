pragma solidity ^0.5.5;

import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "libs/Users.sol";
import "./EscrowRole.sol";
import "./ManagerRole.sol";


contract MyLearn is Ownable, EscrowRole, ManagerRole {
  using Users for Users.User[];
  using Address for Address;
  // IterableMapping.itmap students;

  event LogNewUser(string passportNumber, string name);
  event LogCountOfManagers(uint length);
  event LogIsUserExist(bool isExist);
  event LogNewEscrow(string passportNumber, string name, address indexed addr);
  event LogEscrowWithdrawal(address receiver, uint amount);
  event LogIsStudentApproved(string passportNumber, bool isApproved);

  uint private studentID = 0;
  uint256 private constant _escrowSalary = 0.1 ether;

  struct Escrow {
    string passportNumber;
    string name;
    address payable addr;
  }

  Escrow public escrow;

  struct Student {
    string passportNumber;
    string name;
    bool isApproved;
    bool isRegistered;
  }

  mapping(uint => Student) public students;

  struct Manager {
    string passportNumber;
    string name;
    address payable addr;
  }

  Manager[] managers;

  // common users table for validating passport num
  Users.User[] public users;

  function payForEscrow()
    public
    payable
    onlyManager
  {
    require(
      msg.sender.balance >= _escrowSalary,
      "Address: insufficient balance"
    );
  }

  function getContractBalance() public view returns (uint256) {
    return address(this).balance;
  }

  function approveDiplomas(
    uint[] memory validStudentsIndexes
  )
    public
    onlyEscrow
  {
    require(studentID > 0, "Stundents must be added");
    require(validStudentsIndexes.length > 0, "List of students cannot be empty");
    require(address(this).balance >= _escrowSalary, "Insufficient balance");

    for (uint i = 0; i < validStudentsIndexes.length; i++) {
      students[i].isApproved = true;
    }

    msg.sender.transfer(_escrowSalary);
    emit LogEscrowWithdrawal(msg.sender, _escrowSalary);
  }

  function addEscrow(
    string memory _passportNumber,
    string memory _name,
    address payable _addr
  )
    public
    onlyOwner
  {
    escrow = Escrow({
      passportNumber: _passportNumber,
      name: _name,
      addr: _addr
    });

    emit LogNewEscrow({passportNumber: _passportNumber, name: _name, addr: _addr});
    addEscrow(_addr);
  }

  function addManager(
    string memory _passportNumber,
    string memory _name,
    address payable _addr
  )
    public
    onlyOwner
  {
    emit LogCountOfManagers(managers.length);
    emit LogIsUserExist(users.searchByPassportNumber(_passportNumber));

    require(bytes(_passportNumber).length == 9);
    require(managers.length < 2, "managers length must be < 2");
    require(!users.searchByPassportNumber(_passportNumber), "manager already added earlier");

    users.push(
      Users.User({
        passportNumber: _passportNumber
      })
    );

    managers.push(
      Manager({
        passportNumber: _passportNumber,
        name: _name,
        addr: _addr
      })
    );
    emit LogNewUser(_passportNumber, _name);
    addManagerRole(_addr);
  }

  function createStudent(
    string memory _passportNumber,
    string memory _name
  )
    public
    onlyManager
  {
    require(bytes(_passportNumber).length == 9);
    require(!users.searchByPassportNumber(_passportNumber), "student already added earlier");

    users.push(
      Users.User({
        passportNumber: _passportNumber
      })
    );

    students[studentID] = Student({
      passportNumber: _passportNumber,
      name: _name,
      isApproved: false,
      isRegistered: false
    });

    studentID = studentID + 1;
    emit LogNewUser(_passportNumber, _name);
  }

  function isDiplomaApproved(
    string memory _passportNumber
  ) public returns (bool) {
    require(users.searchByPassportNumber(_passportNumber), "Student: not found");

    for (uint i = 0; i < studentID; i++) {
      if (Users.comparePassportNumbers(students[i].passportNumber, _passportNumber)) {
        emit LogIsStudentApproved(_passportNumber, students[i].isApproved);
        return students[i].isApproved;
      }
    }

    emit LogIsStudentApproved(_passportNumber, false);
    return false;
  }
}
