require 'date'
require 'csv'
@students = [] # an empty array accessible to all methods
@width = 125

def input_students
  puts "Please enter the names of the students".center(@width)
  puts "To finish, just hit return twice".center(@width)
  name = STDIN.gets.chomp.capitalize
  while !name.empty?
    add_height
    add_cohort
    add_students(name, @cohort, @height)
    student_count
    name = STDIN.gets.chomp.capitalize
  end
  @students
end

def student_count
  if @students.length == 1 then puts "Now we have #{@students.count} student".center(@width)
  elsif @students.length > 1 then puts "Now we have #{@students.count} students".center(@width)
  end
end

def add_height
  puts "How tall are they?".center(@width)
  @height = gets.chomp
end

def add_cohort
  puts "What cohort are they in?".center(@width)
  @cohort = gets.chomp.capitalize
  if @cohort.empty?
    @cohort = Date::MONTHNAMES[Date.today.month]
  end
end

def interactive_menu
  loop do
    print_menu
    process(STDIN.gets.chomp)
  end
end

def print_menu
  line_break
  puts "1. Input the students".center(@width)
  puts "2. Show the students".center(@width)
  puts "3. Search students by initial".center(@width)
  puts "4. Show students whose names are shorter than X characters".center(@width)
  puts "5. Organize by cohort".center(@width)
  puts "6. Save the list to students.csv".center(@width)
  puts "7. Load the list from students.csv".center(@width)
  puts "8. Exit".center(@width) # 9 because we'll be adding more items
end

def line_break
  10.times {print "-------------"}
  puts ""
end

def show_students
  print_header
  print_student_list
  print_footer
end

def print_specific_initial
  puts "Which initial would you like to search through?".center(@width)
  initial = gets.chomp
  @students.each do |student| 
    student.each do |key, value|
      if key == :name && value.chr == initial 
        puts value.center(@width) 
      end
    end
  end
end

def print_shorter_than
  puts "How many letters would you like to see?".center(@width)
  input = gets.chomp.to_i
  @students.each do |student|
    student.each do |key, value|
      if key == :name && value.length <= input
        puts value.center(@width)
      end
    end
  end
end

def show_by_cohort
  if @students.empty?
    puts "No students available".center(@width)
  else
    cohorts = @students.map do |student|
      student[:cohort]
    end
  end
  cohorts.uniq.each do |cohort|
    puts "#{cohort} cohort".upcase.center(@width)
    @students.each do |student|  
       if student[:cohort] == cohort
           puts student[:name].center(@width)
       end
    end
  end
end

def process(selection)
  case selection
  when "1"
    input_students
  when "2"
    show_students
  when "3"
    print_specific_initial
  when "4"
    print_shorter_than
  when "5"
    show_by_cohort
  when "6"
    save_students
  when "7"
    load_students
  when "8"
    exit # this will cause the program to terminate
  else
    puts "I don't know what you meant, try again".center(@width)
  end
end

def print_header
  puts "The students of Villains Academy".center(@width)
  line_break
end

def print_student_list
  i = 0
  if @students.count == 0
    puts "No student data available".center(@width)
  else
    while i < @students.count
      puts "#{i + 1}. #{@students[i][:name]} (#{@students[i][:cohort]} cohort)".center(@width)
      i += 1
    end
  end
end

def print_footer
  if @students.count == 1
    puts "Overall, we have #{@students.count} great student".center(@width)
  elsif @students.count > 1
  puts "Overall, we have #{@students.count} great students".center(@width)
  end
end

def save_students
  CSV.open("students.csv", "wb") do |file|
  @students.each do |student|
    file << student_data = [student[:name], student[:cohort], student[:height]]
  end
  puts "Saved".center(@width)
  end
end

def load_students(filename = "students.csv")
  CSV.foreach(filename) do |row|
    name, cohort, height = row
    add_students(name, cohort, height)
  end
  puts "Loaded".center(@width)
end

def add_students(name, cohort, height)
  @students << {name: name, cohort: cohort, height: height}
end

def try_load_students
  filename = ARGV.first
  if filename.nil?
    load_students
    puts "Loaded #{@students.count} from students.csv".center(@width)
  elsif File.exists?(filename)
    load_students(filename)
    puts "Loaded #{@students.count} from #{filename}".center(@width)
  else
    puts "Sorry, #{filename} doesn't exist.".center(@width)
    exit
  end
end

try_load_students
interactive_menu