require 'date'
@students = [] # an empty array accessible to all methods
@width = 125
def input_students
  puts "Please enter the names of the students".center(@width)
  puts "To finish, just hit return twice".center(@width)
  # get the first name
  # while the name is not empty, repeat this code
  name = STDIN.gets.chomp.capitalize
  while !name.empty?
    puts "How tall are they?".center(@width)
    height = gets.chomp
    puts "What cohort are they in?".center(@width)
    cohort = gets.chomp.capitalize
    @students << {name: name, cohort: cohort = (Date::MONTHNAMES[Date.today.month]), height: height}
    puts "Now we have #{@students.count} students".center(@width)
    name = STDIN.gets.chomp.capitalize
  end
  @students
end

def interactive_menu
  loop do
    print_menu
    process(STDIN.gets.chomp)
  end
end

def print_menu
  10.times {print "-------------"}
  puts ""
  puts "1. Input the students".center(@width)
  puts "2. Show the students".center(@width)
  puts "3. Search students by initial".center(@width)
  puts "4. Show students whose names are shorter than X characters".center(@width)
  puts "5. Organize by cohort".center(@width)
  puts "6. Save the list to students.csv".center(@width)
  puts "7. Load the list from students.csv".center(@width)
  puts "9. Exit".center(@width) # 9 because we'll be adding more items
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
  when "9"
    exit # this will cause the program to terminate
  else
    puts "I don't know what you meant, try again".center(@width)
  end
end

def print_header
  puts "The students of Villains Academy".center(@width)
  10.times {print "-------------"}
  puts ""
end

def print_student_list
  i = 0
  while i < @students.count
    puts "#{i + 1}. #{@students[i][:name]} (#{@students[i][:cohort]} cohort)".center(@width)
    i += 1
  end
end

def print_footer
  puts "Overall, we have #{@students.count} great students".center(@width)
end

def save_students
  # open the file for writing
  file = File.open("students.csv", "w")
  # iterate over the array of students 
  @students.each do |student|
    student_data = [student[:name], student[:cohort], student[:height]]
    csv_line = student_data.join(",")
    file.puts csv_line
  end
  file.close
end

def load_students(filename = "students.csv")
  file = File.open(filename, "r")
  file.readlines.each do |line|
    name, cohort, height = line.chomp.split(",")
    @students << {name: name, cohort: cohort, height: height}
  end
  file.close
end

def try_load_students
  filename = ARGV.first
  return if filename.nil?
  if File.exists?(filename)
    load_students(filename)
    puts "Loaded #{@students.count} from #{filename}".center(@width)
  else
    puts "Sorry, #{filename} doesn't exist.".center(@width)
    exit
  end
end

try_load_students
interactive_menu