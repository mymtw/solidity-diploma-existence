const MyLearn = artifacts.require('../MyLearn.sol');
// const web3 = require('web3');
const assert = require('assert');


contract('MyLearn', async accounts => {
  let myLearn,
      escrowSalary = web3.utils.toWei('0.1', 'ether'),
      stud1,
      stud2

  before(async () => {
    myLearn = await MyLearn.deployed()
  })

  it('deploys successfully', async () => {
    const address = await myLearn.address

    assert.notEqual(address, 0x0)
    assert.notEqual(address, '')
    assert.notEqual(address, null)
    assert.notEqual(address, undefined)
  })

  it('ensure that owner is the first address', async  () => {
    const owner = await myLearn.owner()
    assert.equal(owner, accounts[0])
  })

  it('ensure comission managers can be max 2', async () => {
    await myLearn.addManager(
      "MC2402307",
      "Johndoe 1",
      accounts[1],
      {from: accounts[0]}
    )

    await myLearn.addManager(
      "MC2402308",
      "Johndoe 2",
      accounts[2],
      {from: accounts[0]}
    )
  })

  it('adds students/diploma owners before lock', async () => {
    stud1 = await myLearn.createStudent(
      "MC2402309",
      "John Doe 1",
      {from: accounts[1]},
    )
    stud2 = await myLearn.createStudent(
      "MC2402310",
      "John Doe 2",
      {from: accounts[2]},
    )
  })

  it('adds new escrow', async () => {
    await myLearn.addEscrow(
      "MC2402311",
      "John Doe 3",
      accounts[3],
      {from: accounts[0]}
    )

    console.log(await myLearn.escrow())
  })

  it('pay for escrow', async () => {
    owner_balance_before = await web3.eth.getBalance(accounts[0])
    owner_balance_expected = parseInt(owner_balance_before, 10) + parseInt(escrowSalary, 10)

    await myLearn.payForEscrow(
      {from: accounts[1], value: escrowSalary}
    )

    assert.equal(
      web3.utils.fromWei(await myLearn.getContractBalance(), 'ether'),
      web3.utils.fromWei(escrowSalary, 'ether')
    )
  })

  it('approves diplomas for 1st student, and set non validated 2nd', async () => {
    await myLearn.approveDiplomas(
      [0],
      {from: accounts[3]}
    )

    stud1 = await myLearn.students(0)
    stud2 = await myLearn.students(1)

    assert.equal(stud1.isApproved, true)
    assert.equal(stud2.isApproved, false)
  })

  it('checks is students diploma approved by passport number', async () => {
    const stud1_event = await myLearn.isDiplomaApproved(
      stud1.passportNumber
    )

    const stud2_event = await myLearn.isDiplomaApproved(
      stud2.passportNumber
    )

    assert.equal(stud1_event.logs[0].args.isApproved, true)
    assert.equal(stud2_event.logs[0].args.isApproved, false)
  })
})
