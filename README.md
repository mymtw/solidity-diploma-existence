# files in migrations dir creates manually

# then `yarn truffle migrate` or `yarn truffle migrate --reset`

```
yarn truffle compile
yarn truffle migrate --reset
yarn truffle console
yarn truffle test --show-events
```

# get eth byte code:

```
curl -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_getCode","params":["0x8d00bcec9e37d582a9695121260de00c56c48004", "latest"],"id":1}' http://127.0.0.1:8545
```

# generate an ethereum address:
https://kobl.one/blog/create-full-ethereum-keypair-and-address/

# Description

Simple smart contract over ethereum's blockchain,
written in "solidity" lang
needs to check that diploma
has been passed and issued by any type of trusted educational institution
In short: Mainnet will approve that diploma of student hasn't been bought in "subway" e.g.

note: Miners here do not prevents corruption, this is not a goal of blockchain (at least here)
