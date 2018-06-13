require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :id, :name, :grade

  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table

    sql = <<-HELLO
    CREATE TABLE IF NOT EXISTS students
    (id INTEGER PRIMARY KEY,
    name TEXT,
    grade INTEGER)
    HELLO

    DB[:conn].execute(sql)
  end

  def self.drop_table

    sql = <<-HELLO
    DROP TABLE IF EXISTS students
    HELLO

    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
    sql = <<-HELLO
    INSERT INTO students (name, grade)
    VALUES (?, ?)
    HELLO

    DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end
  end

  def self.create(name, grade)
    instance = self.new(name, grade)
    instance.save
    instance
  end

  def self.new_from_db(array)
    id = array[0]
    name = array[1]
    grade = array[2]
    self.new(id, name, grade)
  end

  def self.find_by_name(name)

    sql = <<-HELLO
    SELECT * FROM students
    WHERE name = ?
    HELLO

    array = DB[:conn].execute(sql, name).first
    self.new_from_db(array)
  end

  def update

    sql = <<-HELLO
    UPDATE students SET name = ?, grade = ? WHERE id = ?
    HELLO

    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end



end
