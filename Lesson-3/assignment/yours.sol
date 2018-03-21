pragma solidity ^0.4.14;
contract Payroll{
    struct Employee {
        address id;
        uint salary;
        uint lastPayDay;
    }
    uint  payDuration = 10 seconds;
    address owner;
    mapping(address => Employee) employees;
    uint totalSalary;
    
    function Payroll(){
        owner = msg.sender;
    }
    
    function _partialPaid(Employee employee) private{
        uint payAmount = employee.salary * (now - employee.lastPayDay) / payDuration;
        employee.id.transfer(payAmount);
    }
    
    function addEmployee(address employeeId, uint salary){
        require(msg.sender == owner);
        var employee =employees[employeeId];
        assert(employee.id == 0x0);
        totalSalary += salary * 1 ether;
        employees[employeeId] = Employee(employeeId, salary * 1 ether,now);
    }
    
    function removeEmployee(address employeeId){
        require(msg.sender == owner);
        var  employee = employees[employeeId];
        assert(employee.id != 0x0);
        _partialPaid(employee);
        totalSalary -= employees[employeeId].salary;
        delete employees[employeeId];
    }

    function updateEmployee(address employeeId, uint salary){
        require(msg.sender == owner);
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        
        _partialPaid(employee);
        totalSalary -= employees[employeeId].salary;
        employees[employeeId].salary = salary * 1 ether;
        totalSalary += employees[employeeId].salary;
        employees[employeeId].lastPayDay = now;
    }
    
     function caclulateRunway()  returns (uint){
      return this.balance / totalSalary;
  }
   
   function addFund() public payable returns (uint){
       return this.balance;
   }

  
  function hasEnoughFund() private returns (bool) {
      return caclulateRunway() > 0;
  }
  
  function getPaid() public {
     var employee = employees[msg.sender];
     assert(employee.id != 0x0);
     
     uint nextPayday = employee.lastPayDay + payDuration;
     assert(nextPayday < now);
     employees[msg.sender].lastPayDay = nextPayday;
     employee.id.transfer(employee.salary);
  }
}