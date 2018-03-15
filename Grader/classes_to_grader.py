###############################################################################
## Name       : classes_to_grader                                             # 
## Author     : Abel Gancsos                                                  #
## Version    : v. 1.0.0                                                      #
## Created    : 02/26/2018                                                    #
## Description:                                                               #
###############################################################################

import os;
import sys;
import sqlite3;

"""
    This class helps migrate a Classes.db database to a Grader database
"""
class ClassesToGrader:
    classes_file = "";
    program_name = "";
    institution_name = "";
    college_name = "";
    classes_db_handler = None;
    classes_db_cursor = None;
    grader_db_handler = None;
    grader_db_cursor = None;
    program_id = 0;
    institution_id = 0;
    college_id = 0;
    user_id = 0;

    '''
        This is the default constructor for the class
    '''
    def __init__(self):
        pass;

    def import_institution(self):
        self.grader_db_cursor.execute("select count(*) from institution where institution_name = '" + self.institution_name + "'");
        total = self.grader_db_cursor.fetchone()[0];
        if(total == 0):
            self.grader_db_cursor.execute("insert into institution (institution_name) values ('" + self.institution_name + "')");
            self.grader_db_handler.commit();
        self.grader_db_cursor.execute("select institution_id from institution where institution_name = '" + self.institution_name + "'");
        self.institution_id = self.grader_db_cursor.fetchone()[0];
        ##print("Institution: " + str(self.institution_id));
        pass;

    def import_college(self):
        self.grader_db_cursor.execute("select count(*) from college where college_name = '" + self.college_name + "'");
        total = self.grader_db_cursor.fetchone()[0];
        if(total == 0):
            self.grader_db_cursor.execute("insert into college (institution_id,college_name) values ('" + str(self.institution_id) + "','" + self.college_name + "')");
            self.grader_db_handler.commit();
        self.grader_db_cursor.execute("select college_id from college where college_name = '" + self.college_name + "'");
        self.college_id = self.grader_db_cursor.fetchone()[0];
        ##print("College: " + str(self.college_id));
        pass;

    def import_program(self):
        self.grader_db_cursor.execute("select count(*) from program where program_name = '" + self.program_name + "'");
        total = self.grader_db_cursor.fetchone()[0];
        if(total == 0):
            self.grader_db_cursor.execute("insert into program (college_id,program_name) values ('" + str(self.college_id) + "','" + self.program_name + "')");
            self.grader_db_handler.commit();
        self.grader_db_cursor.execute("select program_id from program where program_name = '" + self.program_name + "'");
        self.program_id = self.grader_db_cursor.fetchone()[0];
        ##print("Program: " + str(self.program_id));
        pass;

    def import_instructors(self):
        self.classes_db_cursor.execute("select * from courses");
        for raw_row in self.classes_db_cursor.fetchall():
            full_name = raw_row[4];
            if(full_name != ""):
                comps = full_name.split(" ");
                if(len(comps) > 1):
                    self.grader_db_cursor.execute("select count(*) from users where user_firstname = '" + comps[0] + "' and user_lastname = '" + comps[1] + "'");
                    total = self.grader_db_cursor.fetchone()[0];
                    if(total == 0):
                        self.grader_db_cursor.execute("insert into users (user_firstname,user_lastname,user_type) values ('" + comps[0] + "','" + comps[1] + "','Instructor')");
                        self.grader_db_handler.commit();
        pass;

    def import_courses(self):
        self.classes_db_cursor.execute("select * from courses");
        for raw_row in self.classes_db_cursor.fetchall():
            course_number = raw_row[2] + "" + raw_row[3];
            course_name = raw_row[5];
            course_sem = raw_row[6];
            course_year = raw_row[7];
			notes = raw_row[9];
            instructor_id = 0;

            if(course_number != ""):
                full_name = raw_row[4];
                comps = full_name.split(" ");
                if(len(comps) > 1):
                    self.grader_db_cursor.execute("select user_id from users where user_firstname = '" + comps[0] + "' and user_lastname = '" + comps[1] + "'");
                    instructor_id = self.grader_db_cursor.fetchone()[0];
                self.grader_db_cursor.execute("select count(*) from course where course_number = '" + course_number + "'");
                total = self.grader_db_cursor.fetchone()[0];
                if(total == 0):
                    long_query = "insert into course (course_number,course_name,course_semester,course_year,course_instructor,course_notes) values (";
                    long_query += ("'" + course_number + "','" + course_name + "','");
                    long_query += (course_sem + "','" + course_year + "'");
                    long_query += (",'" + str(instructor_id) + "','" + notes + "'");
                    long_query += ")";
                    self.grader_db_cursor.execute(long_query);
                    self.grader_db_handler.commit();
        pass;

    def import_grade_types(self):
        self.classes_db_cursor.execute("select distinct a.course_number,b.grade_type from courses a join grades b on a.id = b.course_id");
        for raw_row in self.classes_db_cursor.fetchall():
            course_number = raw_row[0];
            grade_type = raw_row[1];
            course_id = 0;
            grade_type_id = 0;
            self.grader_db_cursor.execute("select course_id from course where course_number like '%" + course_number + "%'");
            course_id = self.grader_db_cursor.fetchone()[0];
            self.grader_db_cursor.execute("select grade_type_id from grade_type where lower(grade_type_name) like '" + grade_type + "'");
            grade_type_id = self.grader_db_cursor.fetchone()[0];
            if(grade_type_id != 0 and course_id != 0):
                self.grader_db_cursor.execute("select count(*) from grade_weight where grade_type = '" + str(grade_type_id) + "' and course_id = '" + str(course_id) + "'");
                total = self.grader_db_cursor.fetchone()[0];
                if(total == 0):
                    self.grader_db_cursor.execute("insert into grade_weight (grade_type,course_id) values ('" + str(grade_type_id) + "','" + str(course_id) + "')");
                    self.grader_db_handler.commit();
        pass;

    def import_grades(self):
        sql = "select c.course_title,g.grade_type,g.actual_grade,g.grade_name,g.notes from grades g join courses c on g.course_id = c.id";
        self.classes_db_cursor.execute(sql);
        for raw_row in self.classes_db_cursor.fetchall():
            class_name = raw_row[0];
            grade_type = raw_row[1];
            grade_value = raw_row[2];
            grade_name = raw_row[3];
            grade_notes = raw_row[4].replace("'","''");
            class_id = 0;
            grade_type_id = 0;
            grade_weight_id = 0;
            self.grader_db_cursor.execute("select course_id from course where course_name = '" + class_name + "'");
            class_id = self.grader_db_cursor.fetchone()[0];
            self.grader_db_cursor.execute("select grade_type_id from grade_type where lower(grade_type_name) = '" + grade_type + "'");
            grade_type_id = self.grader_db_cursor.fetchone()[0];
            self.grader_db_cursor.execute("select grade_weight_id from grade_weight where grade_type = '" + str(grade_type_id) + "' and course_id = '" + str(class_id) + "'");
            grade_weight_id = self.grader_db_cursor.fetchone()[0];
            sql = "select count(*) from grade where grade_name = '" + grade_name + "' and student_id = '" + str(self.user_id) + "' and grade_type = '" + str(grade_type_id) + "'";
            self.grader_db_cursor.execute(sql);
            total = self.grader_db_cursor.fetchone()[0];
            if(total == 0):
                sql = "insert into grade (student_id,grade_type,grade_name,course_id,grade_weight,grade_notes) values (";
                sql += ("'" + str(self.user_id) + "','" + str(grade_type_id) + "','" + grade_name + "','" + str(class_id) + "','" + str(grade_weight_id) + "','" + grade_notes + "'"); 
                sql += ")";
                self.grader_db_cursor.execute(sql);
                self.grader_db_handler.commit();
        pass;

    '''
        This method performs all operations for the migration
    '''
    def migrate(self):
        grader_path = os.path.expanduser("~") + "/Library/Application Support/Grader/Grader.gbk";
        if(os.path.exists(grader_path)):
            if(self.classes_file != "" and self.institution_name != "" and self.program_name != "" and self.college_name != ""):
                
                ## Open connections to the data sources
                self.grader_db_handler = sqlite3.connect(grader_path);
                self.grader_db_cursor = self.grader_db_handler.cursor();
                self.classes_db_handler = sqlite3.connect(self.classes_file);
                self.classes_db_cursor = self.classes_db_handler.cursor();

                ##print("".zfill(80).replace("0","-"));

                '''
                    Find user id
                '''
                self.grader_db_cursor.execute("select user_id from users where user_firstname != ''");
                raw_result = self.grader_db_cursor.fetchone();
                self.user_id = raw_result[0];
                ##print("User: " + str(self.user_id));
            
                '''
                    Core migration tasks
                '''    
                self.import_institution();
                self.import_college();
                self.import_program();
                self.import_instructors();
                self.import_courses();
                self.import_grade_types();
                self.import_grades();

                ##print("".zfill(80).replace("0","-"));                

                ## Close connections to the data sources
                self.grader_db_handler.commit();
                self.grader_db_handler.close();
                self.classes_db_handler.close();
                pass;
            else:
                print("Error... You must provide values to all fields....");
            pass;
        else:
            print("You do not have Grader installed....");
            pass;
    pass;



"""
    This function prints out details on how to run this utility
"""
def print_menu():
    print("".zfill(80).replace("0","="));
    print("* Name          : classes_to_grader");
    print("* Author        : Abel Gancsos");
    print("* Version       : v. 1.0.0");
    print("* Description   :");
    print("* Flags         :");
    print("    * -f: Full path to the Classes.db file to migrate from");
    print("    * -i: Name of the institution to migrate from");
    print("    * -c: Name of the college in the institution");
    print("    * -p: Name of the program");
    print("".zfill(80).replace("0","="));
    pass;

"""
    This is the main entry point to the utility from the command-line
"""
if __name__ == "__main__":

    help = False;
    session = ClassesToGrader();

    if(len(sys.argv) > 1):
        for arg_index in range(0,len(sys.argv)):
            if(sys.argv[arg_index] == "-f"):
                session.classes_file = sys.argv[arg_index + 1];
            elif(sys.argv[arg_index] == "-i"):
                session.institution_name = sys.argv[arg_index + 1];
            elif(sys.argv[arg_index] == "-p"):
                session.program_name = sys.argv[arg_index + 1];
            elif(sys.argv[arg_index] == "-c"):
                session.college_name = sys.argv[arg_index + 1];
            elif(sys.argv[arg_index] == "-h"):
                help = True;
            pass;
        pass;
        if(help):
            print_menu();
        else:
            session.migrate();
    else:
        print_menu();
    pass;
