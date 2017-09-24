pragma solidity ^0.4.15;

// Base class to be used by contracts that need to enforce ownership
contract Owners {

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

    function addOwner()
        public
        fromMasterOwner()
        returns (bool)
    {
        return true;
    }

    function removeOwner()
        public
        fromMasterOwner()
        returns (bool)
    {
        return true;
    }

}
