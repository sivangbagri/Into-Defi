// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Structs{
    struct Car{
        string model;
        uint year;
        address owner;
    }
    Car public car;
    Car[] public cars;
    mapping(uint => Car[]) public carsByOwner;
    function examples() external{
        Car memory toyota= Car("Toyota",1990,msg.sender);
        Car memory lambo = Car({year:1980, model:"Lamborghini",owner:msg.sender});
        Car memory tesla;
        tesla.model="Tesla";
        cars.push(toyota);

        Car storage car1 =cars[0];
        car1.year=2000;
        delete car1.owner ;// reset back to default;
    }
}