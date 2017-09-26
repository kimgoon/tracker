pragma solidity ^0.4.15;

// Base class to be used by contracts that need to enforce ownership
// between multiple users, still requires a master owner
contract Owners {

    event LogAddOwner(address masterOwner, address newOwner);
    event LogRemoveOwner(address masterOwner, address newOwner);
    event LogChangeMasterOwner(address previousOwner, address newOwner);

    address masterOwner;

    mapping(address => uint) owners;
    address[] ownersIndex;

    function Owners() {
        masterOwner = msg.sender;
    }

    modifier fromMasterOwner() {
        require(msg.sender == masterOwner);
        _;
    }
    modifier fromOneOfOwner() {
        require(isOwner(msg.sender));
        _;
    }

    function getMasterOwner()
        public
        returns (address)
    {
        return masterOwner;
    }

    function isOwner(address _address)
        public
        returns (bool)
    {
        require(ownersIndex.length > 0);
        return (ownersIndex[owners[_address]] == _address);
    }

    function addOwner(address _address)
        public
        fromMasterOwner()
        returns (bool)
    {
        require(isOwner(_address) == false);

        owners[_address] = ownersIndex.push(_address) - 1;
        LogAddOwner(msg.sender, _address);
        return true;
    }

    function removeOwner(address _address)
        public
        fromMasterOwner()
        returns (bool)
    {
        require(isOwner(_address) == true);

        uint targetAddressIndex = owners[_address];
        address addressToMove = ownersIndex[ownersIndex.length-1];

        ownersIndex[targetAddressIndex] = addressToMove;
        owners[addressToMove] = targetAddressIndex;
        ownersIndex.length--;

        LogRemoveOwner(msg.sender, _address);
        return true;
    }

    function changeMasterOwner(address _address)
        public
        fromMasterOwner()
        returns (bool)
    {
        address previousOwner = masterOwner;
        masterOwner = _address;
        LogChangeMasterOwner(previousOwner, masterOwner);
    }
}
