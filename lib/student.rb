require 'pry'

class Student
  attr_accessor :id, :name, :grade
  #
  #
  def initialize(id:nil, name:nil, grade:nil)
    @id = id
    @name = name
    @grade = grade
  end

  #

  def self.new_from_db(row)
      Student.new(id:row[0], name:row[1], grade:row[2])
    # create a new Student object given a row from the database
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
        SELECT *
        FROM students
      SQL

      DB[:conn].execute(sql).map do |row|
        self.new_from_db(row)
      end
  end


  def self.find_by_name(name)
      sql = <<-SQL
        SELECT * FROM students WHERE name = ?
      SQL


          value = DB[:conn].execute(sql, name).flatten
          Student.new(name:value[1],grade:value[2],id:value[0])

  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end



  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

def self.all_students_in_grade_9
  #returns the number
  sql = <<-SQL
    SELECT COUNT(*) FROM students WHERE grade = 9
  SQL

   DB[:conn].execute(sql).map do |row|
     self.new_from_db(row)
   end
 end




 def self.students_below_12th_grade
   #returns the array
   sql = <<-SQL
     SELECT * FROM students WHERE grade < 12
   SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end


  def self.first_X_students_in_grade_10(number)
    #returns the number
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT ?
    SQL

     DB[:conn].execute(sql, number).map do |row|
       self.new_from_db(row)
     end
   end


   def self.first_student_in_grade_10
     sql = <<-SQL
       SELECT * FROM students WHERE grade = 10 LIMIT 1
     SQL

      DB[:conn].execute(sql).map do |row|
        self.new_from_db(row)
      end.first
   end


   def self.all_students_in_grade_X(grade)
     sql = <<-SQL
       SELECT * FROM students WHERE grade = ?
     SQL

      DB[:conn].execute(sql, grade).map do |row|
        self.new_from_db(row)
      end
    end



end
