class Employee
  attr_reader :name, :title, :salary, :boss
  def initialize(name, title, salary)
    @name = name
    @title = title
    @salary = salary
  end

  def add_boss(boss)
    @boss.remove_employee(self) unless @boss.nil?
    @boss = boss
  end

  def calculate_bonus(multiplier)
    bonus = @salary * multiplier
  end
end

class Manager < Employee
  attr_reader :employees
  def initialize(name, title, salary)
    super(name, title, salary)
    @employees = []
  end

  def assign_employee(employee)
    unless employees.include?(employee)
      employees << employee
      employee.add_boss(self)
    end
    self
  end

  def remove_employee(employee)
    employees.delete(employee)
  end

  def calculate_bonus(multiplier)
    bonus = employees.inject(0) do |sum, employee|
      sum += employee.salary if employee.is_a?(Manager)
      sum + employee.calculate_bonus(multiplier)
    end
  end
end

=begin
e1 = Employee.new("e1", "peon", 50000)
e2 = Employee.new("e2", "peon", 60000)
e3 = Employee.new("e3", "peon", 70000)
m1 = Manager.new("m1", "manager", 100000)
m2 = Manager.new("m2", "director", 1000000)

m1.assign_employee(e1).assign_employee(e2).assign_employee(e3)
m2.assign_employee(m1)
p e1.calculate_bonus(1.5)
p m1.calculate_bonus(1)
p m2.calculate_bonus(100)
=end