conn system/dunno;
create user labproject identified by password;
grant all privilege to labproject;
conn labproject/password;
set serveroutput on;


--tables:

--Dept:to store department

create table dept(
code varchar2(4),
Name varchar2(50),
constraint dept_pk primary key(code)
);

--Batch-to store batch info;
create table batch (
dept varchar2(5),
semester number,
constraint fk_batch_dept foreign key(dept) references dept(code),
constraint batch_unique unique(dept,semester)
);

--Teacher: to store teacher's info;

create table teacher(
code varchar2(5),
name varchar2(50),
dept varchar2(5),
designation varchar2(20),
constraint teacher_pk primary key(code),
constraint fk_teacher_dept foreign key(dept) references dept(code),
constraint check_teacher_designation check(designation in('Professor','Associate Professor','Assistant Professor','Lecturer'))
);


--course: to store course info

create table course(
code varchar2(10),
name varchar2(50),
credit number,
dept varchar2(5),
semester number,
ctype varchar2(7),
constraint course_pk primary key(code),
constraint fk_course_batch foreign key(dept,semester) references batch(dept,semester),
constraint check_ctype check(ctype in ('Theory','Lab'))
);

--Lab: to store Lab info
create table lab(
lab_no varchar2(10),
location varchar2(40),
building_level number,
constraint pk_lab primary key(lab_no)
);

--classroom: to store classroom info
create table classroom(
room_no varchar2(10),
location varchar2(40),
building_level number,
constraint pk_classroom primary key(room_no)
);


--procedures

--procedures and triggers related to DEPT table
--add dept
create or replace procedure add_dept(a in varchar2,b in varchar2)
as
begin
insert into dept(code,Name) values(a,b);
end;

--block to call add_dept
declare
	code varchar2(4);
	name varchar2(50);

begin
	code:='&input_department_code';
	name:='&input_department_name';
	add_dept(code,name);
end;
/

--delete dept
create or replace procedure delete_dept(a in varchar2)
as
begin
delete from dept where code=a;
end;

--block to call delete_dept
declare
	code varchar2(4);

begin
	
	code:='&input_department_code';
	delete_dept(code);
end;
/

--show all dept
create or replace procedure show_all_dept
as
c varchar2(4);
cursor c1 is select * from dept;
begin
dbms_output.put_line('code'|| ' '||'Dept_Name');
for e in c1 loop
c:=e.code;
c:=rpad(c,4);
dbms_output.put_line(c|| ' '||e.Name);
end loop;
end;
/
--block to call show_all_dept


begin
	show_all_dept();
end;
/



--procedures and triggers related to BATCH table
--add dept
create or replace procedure add_batch(a in varchar2,b in number)
as
begin
insert into batch(dept,semester) values(a,b);
end;

--block to call add_dept
declare
	dept varchar2(5);
	semester number;

begin
	dept:='&input_department_code';
	semester:=&input_semester;
	add_batch(dept,semester);
end;
/



--delete batch
create or replace procedure delete_batch(a in varchar2,b in number)
as
begin
delete from batch where dept=a and semester=b;
end;

--block to call delete_dept
declare
	dept varchar2(5);
	semester number;
begin
	dept:='&input_department_code';
	semester:=&input_semester;
	delete_batch(dept,semester);
end;
/
--show all batch
create or replace procedure show_all_batch
as
c varchar2(4);
cursor c1 is select * from batch;
begin
dbms_output.put_line('code'|| ' '||'Dept_Name');
for e in c1 loop
c:=e.dept;
c:=rpad(c,4);
dbms_output.put_line(c|| ' '||e.semester);
end loop;
end;
/
--block to call show_all_batch


begin
	show_all_batch();
end;
/


--procedures and triggers related to TEACHER table
--add teacher
create or replace procedure add_teacher(a in varchar2,b in varchar2,c in varchar2,d in varchar2)
as
begin
insert into teacher(code,name,dept,designation) values(a,b,c,d);
end;

--block to call add_teacher
declare
	code varchar2(5);
	name varchar2(50);
	dept varchar2(5);
	designation varchar2(20);

begin
	code:='&input_teacher_code';
	name:='&input_teacher_name';
	dept:='&input_department_code';
	designation:='&input_designation';
	
	add_teacher(code,name,dept,designation);
end;
/



--delete teacher
create or replace procedure delete_teacher(a in varchar2)
as
begin
delete from teacher where code=a;
end;

--block to call delete_teacher
declare
	code varchar2(5);
begin
	code:='&input_teacher_code';
	delete_teacher(code);
end;
/


--update teacher
create or replace procedure update_teacher(a in varchar2,b in varchar2,c in varchar2,d in varchar2)
as
begin
update teacher
set name=b,dept=c,designation=d
where code=a;
end;

--block to call update_teacher
declare
	code varchar2(5);
	name varchar2(50);
	dept varchar2(5);
	designation varchar2(20);

begin
	code:='&input_teacher_code';
	name:='&input_teacher_name';
	dept:='&input_department_code';
	designation:='&input_designation';
	
	update_teacher(code,name,dept,designation);
end;
/


--show all teacher
create or replace procedure show_all_teacher
as
	a varchar2(5);
	b varchar2(50);
	c varchar2(5);
	d varchar2(20);
cursor c1 is select * from teacher;
begin
a:=rpad('code',5);
b:=rpad('name',50);
c:=rpad('dept',5);
d:=rpad('designation',20);
dbms_output.put_line(a||' '||b||' '||c||' '||d);
for e in c1 loop
a:=e.code;
a:=rpad(a,5);
b:=e.name;
b:=rpad(b,50);
c:=e.dept;
c:=rpad(c,5);
d:=e.designation;
d:=rpad(d,20);
dbms_output.put_line(a||' '||b||' '||c||' '||d);
end loop;
end;
/
--block to call show_all_teacher


begin
	show_all_teacher();
end;
/


--procedures and triggers related to COURSE table
--add course
create or replace procedure add_course(a in varchar2,b in varchar2,e in number,c in varchar2,f in number,d in varchar2)
as
begin
insert into course(code,name,credit,dept,semester,ctype) values(a,b,e,c,f,d);
end;

--block to call add_course
declare
	code varchar2(10);
	name varchar2(50);
	credit number;
	dept varchar2(5);
	semester number;
	ctype varchar2(7);

begin
	code:= '&unique_subject_code';
	name:='&course_name';
	credit:=&course_credit;
	dept:='&department_code';
	semester:=&input_semester;
	ctype:='&theory_or_lab';
	
	add_course(code,name,credit,dept,semester,ctype);
end;
/



--delete course
create or replace procedure delete_course(a in varchar2)
as
begin
delete from course where code=a;
end;

--block to call delete_course
declare
	code varchar2(5);
begin
	code:='&input_course_code';
	delete_course(code);
end;
/

--update course
create or replace procedure update_course(a in varchar2,b in varchar2,e in number,c in varchar2,f in number,d in varchar2)
as
begin
update course
set name=b,credit=e,dept=c,semester=f,ctype=d
where code=a;
end;

--block to call update_course
declare
	code varchar2(10);
	name varchar2(50);
	credit number;
	dept varchar2(5);
	semester number;
	ctype varchar2(7);

begin
	code:= '&subject_code';
	name:='&course_name';
	credit:=&course_credit;
	dept:='&department_code';
	semester:=&input_semester;
	ctype:='&theory_or_lab';
	
	update_course(code,name,credit,dept,semester,ctype);
end;
/




--show all course
create or replace procedure show_all_course
as
	a varchar2(10);
	b varchar2(50);
	c number;
	c2 varchar2(7);
	d varchar2(10);
	e number;
	e2 varchar2(8);
	f varchar2(7);
cursor c1 is select * from course;
begin
a:=rpad('Code',10);
b:=rpad('Name',50);
c2:=rpad('Credit',7);
d:=rpad('Department',10);
e2:=rpad('Semester',8);
f:=rpad('Type',7);
dbms_output.put_line(a||' '||b||' '||c2||' '||d||' '||e2||' '||f);
for m in c1 loop
a:=m.code;
a:=rpad(a,10);
b:=m.name;
b:=rpad(b,50);
c:=m.credit;
c2:=to_char(c);
c2:=lpad(c2,7);
d:=m.dept;
d:=rpad(d,10);
e:=m.semester;
e2:=to_char(e);
e2:=lpad(e2,8);
f:=m.ctype;
f:=rpad(f,7);
dbms_output.put_line(a||' '||b||' '||c2||' '||d||' '||e2||' '||f);
end loop;
end;
/
--block to call show_all_course


begin
	show_all_course();
end;
/



--procedures and triggers related to Lab table
--add Lab
create or replace procedure add_lab(a in varchar2,b in varchar2,e in number)
as
begin
insert into lab(lab_no,location,building_level) values(a,b,e);
end;

--block to call add_lab
declare
	lab_no varchar2(10);
	location varchar2(40);
	building_level number;

begin
	lab_no:= '&lab_no';
	location:='&building';
	building_level:=&level;
	
	
	add_lab(lab_no,location,building_level);
end;
/



--delete lab
create or replace procedure delete_lab(a in varchar2)
as
begin
delete from lab where lab_no=a;
end;

--block to call delete_lab
declare
	lab_no varchar2(10);
begin
	lab_no:='&input_lab_no';
	delete_lab(lab_no);
end;
/

--update lab
create or replace procedure update_lab(a in varchar2,b in varchar2,e in number)
as
begin
update lab
set location=b,building_level=e
where lab_no=a;
end;

--block to call update_lab
declare
	lab_no varchar2(10);
	location varchar2(40);
	building_level number;

begin
	lab_no:= '&lab_no';
	location:='&building';
	building_level:=&building_level;
	
	update_lab(lab_no,location,building_level);
end;
/




--show all lab
create or replace procedure show_all_lab
as
	a varchar2(10);
	b varchar2(40);
	c number;
	c2 varchar2(7);
	
cursor c1 is select * from lab;
begin
a:=rpad('Lab No',10);
b:=rpad('Location',40);
c2:=rpad('Level',7);
dbms_output.put_line(a||' '||b||' '||c2);
for m in c1 loop
a:=m.lab_no;
a:=rpad(a,10);
b:=m.location;
b:=rpad(b,40);
c:=m.building_level;
c2:=to_char(c);
c2:=lpad(c2,7);
dbms_output.put_line(a||' '||b||' '||c2);
end loop;
end;
/
--block to call show_all_lab


begin
	show_all_lab();
end;
/



--procedures and triggers related to CLASSROOM table
--add Classroom
create or replace procedure add_classroom(a in varchar2,b in varchar2,e in number)
as
begin
insert into classroom(room_no,location,building_level) values(a,b,e);
end;

--block to call add_classroom
declare
	room_no varchar2(10);
	location varchar2(40);
	building_level number;

begin
	room_no:= '&room_no';
	location:='&building';
	building_level:=&level;
	
	
	add_classroom(room_no,location,building_level);
end;
/



--delete classroom
create or replace procedure delete_classroom(a in varchar2)
as
begin
delete from classroom where room_no=a;
end;

--block to call delete_classroom
declare
	room_no varchar2(10);
begin
	room_no:='&input_room_no';
	delete_classroom(room_no);
end;
/

--update classroom
create or replace procedure update_classroom(a in varchar2,b in varchar2,e in number)
as
begin
update classroom
set location=b,building_level=e
where room_no=a;
end;

--block to call update_classroom
declare
	room_no varchar2(10);
	location varchar2(40);
	building_level number;

begin
	room_no:= '&room_no';
	location:='&building';
	building_level:=&building_level;
	
	update_classroom(room_no,location,building_level);
end;
/




--show all classroom
create or replace procedure show_all_classroom
as
	a varchar2(10);
	b varchar2(40);
	c number;
	c2 varchar2(7);
	
cursor c1 is select * from classroom;
begin
a:=rpad('Room No',10);
b:=rpad('Location',40);
c2:=rpad('Level',7);
dbms_output.put_line(a||' '||b||' '||c2);
for m in c1 loop
a:=m.room_no;
a:=rpad(a,10);
b:=m.location;
b:=rpad(b,40);
c:=m.building_level;
c2:=to_char(c);
c2:=lpad(c2,7);
dbms_output.put_line(a||' '||b||' '||c2);
end loop;
end;
/
--block to call show_all_classroom


begin
	show_all_classroom();
end;
/




--Class Scheduling System is done here

create table routine(
dept varchar2(5),
semester number,
course varchar2(10),
teacher varchar2(5),
cday varchar2(5),
slot number,
ctype varchar2(7),
nocls number,
room varchar2(10),
lab varchar2(10),
constraint fk_routine_semester foreign key(dept,semester) references batch(dept,semester),
constraint fk_routine_course foreign key(course) references course(code),
constraint fk_routine_teacher foreign key(teacher) references teacher(code),
constraint fk_routine_room foreign key(room) references classroom(room_no),
constraint fk_routine_lab foreign key(lab) references lab(lab_no),
constraint check_routine_cday check(cday in('Mon','Tues','Wed','Thurs','Fri'))
);


--add in routine table

--block to call add_routine
begin
add_routine();
end;



create or replace procedure add_routine
as

begin
show_all_dept();
dbms_output.put_line('Choose Department');
end;


declare
a varchar2(5);
begin

a:='&department_code';
dbms_output.put_line('Choose Semester');
show_semester(a);
end;


create or replace procedure show_semester(d in varchar2)
as
	s number;
	cursor c1 is
    select * from batch where dept=d; 
begin
	for rec in c1
	loop
	s:=rec.semester;
	dbms_output.put_line(s);
	end loop;
	dbms_output.put_line('Choose Semester');
	choose_semester(d);
end;


create or replace procedure choose_semester(d in varchar2)
as 
	s number;
begin 
	s:=&semester;
	show_routine(d,s);
	dbms_output.put_line('Choose Course');
	show_course(d,s);
end;


create or replace procedure show_course(d in varchar2,s number)
as
	x varchar2(10);
	cursor c1 is
	select code from course where dept=d and semester=s and code not in(select course from routine where dept=d and semester=s);
begin
	for rec in c1
	loop
	x:=rec.code;
	dbms_output.put_line(x);
	end loop;
	choose_course(d,s);
end;


create or replace procedure choose_course(d in varchar2,s number)
as 
	cr varchar2(10);
begin
	cr:='&course_id';
	dbms_output.put_line('Choose teacher');
	show_teacher(d,s,cr);
end;


create or replace procedure show_teacher(d in varchar2,s in number,cr in varchar2)
as
	te varchar2(5);
	cursor c1 is 
	select * from teacher where dept=d;
begin
	for rec in c1
	loop
	te:=rec.code;
	dbms_output.put_line(te);
	end loop;
	choose_teacher(d,s,cr);
end;


create or replace procedure choose_teacher(d in varchar2,s in number,cr in varchar2)
as
	te varchar2(5);
begin
	te:='&teacher_code';
	set_schedule(d,s,cr,te);
end;


create or replace procedure set_schedule(d in varchar2,s in number,cr in varchar2,te in varchar2)
as
	credit_hour course.credit%type;
	ct course.ctype%type;
	x number;
begin 
	select credit into credit_hour from course where code=cr;
	select ctype into ct from course where code=cr;
	if(ct='Lab') then
		credit_hour:=ceil(credit_hour * 2);
	end if;
	x:=1;
	loop
		if(x>credit_hour) then
			exit;
		end if;
		dbms_output.put_line('Choose day for class' || x);
		dbms_output.put_line('Mon Tues Wed Thurs Fri');
		choose_day(d,s,cr,te,x);
		x:=x+1;
	end loop;

end;


create or replace procedure choose_day(d in varchar2,s in number,cl in varchar2,te in varchar2,cn in number)
as
	cd varchar2(5);
begin
	cd:='&day';
	show_slot(d,s,cl,te,cn,cd);
end;


create or replace procedure show_slot(d in varchar2,s in number,cl in varchar2,te in varchar2,cn in number,cd in varchar2)
as	
	x number;
	flag number;
	cursor cbatch is
	select * from routine where dept=d and semester=s and cday=cd;
	cursor c2 is 
	select * from routine where teacher=te and cday=cd;
begin 
	flag:=0;
	for x in 1 .. 9 loop
	for rec in cbatch 
	loop
	 if(x=rec.slot) then
	 flag:=1;
	 end if;
	end loop;
	for j in c2 
	loop
	 if(x=j.slot) then
	 flag:=1;
	 end if;
	end loop;
	if(flag=0) then 
		dbms_output.put_line(x);
	end if;
	flag:=0;
	end loop;
	choose_slot(d,s,cl,te,cn,cd);
end;


create or replace procedure choose_slot(d in varchar2,s in number,cl in varchar2,te in varchar2,cn in number,cd in varchar2)
as
	sl number;
begin
	sl:=&slot;
	show_room(d,s,cl,te,cn,cd,sl);
end;


create or replace procedure show_room(d in varchar2,s in number,cl in varchar2,te in varchar2,cn in number,cd in varchar2,sl in number)
as
	ct course.ctype%type;
	st varchar2(10);
	cursor cclass is select room_no from classroom where room_no not in(select room from routine where cday=cd and slot=sl);
	cursor clab is select lab_no from lab where lab_no not in(select lab from routine where cday=cd and slot=sl);
begin
	select ctype into ct from course where code=cl;
	if(ct='Theory') then
	 dbms_output.put_line('Select Room');
	 for rec in cclass
     loop
        st:=rec.room_no;
		dbms_output.put_line(st);
     end loop;
	 choose_room(d,s,cl,te,cn,cd,sl);
	
	elsif(ct='Lab') then
	 dbms_output.put_line('Select Lab');
	 for rec in clab
     loop
        st:=rec.lab_no;
		dbms_output.put_line(st);
     end loop;
	 choose_lab(d,s,cl,te,cn,cd,sl);
	
	end if;
end;


create or replace procedure choose_room(d in varchar2,s in number,cl in varchar2,te in varchar2,cn in number,cd in varchar2,sl in number)
as
  st varchar2(10);
begin
	st:='&room';
	save_routine(d,s,cl,te,cn,cd,sl,st,0);
end;


create or replace procedure choose_lab(d in varchar2,s in number,cl in varchar2,te in varchar2,cn in number,cd in varchar2,sl in number)
as
  st varchar2(10);
begin
	st:='&lab';
	save_routine(d,s,cl,te,cn,cd,sl,0,st);
end;


create or replace procedure save_routine(d in varchar2,s in number,cl in varchar2,te in varchar2,cn in number,cd in varchar2,sl in number,rm in varchar2,lb in varchar2)
as
   ct course.ctype%type;
begin
	select ctype into ct from course where code=cl;
	insert into routine(dept,semester,course,teacher,cday,slot,ctype,nocls,room,lab) values(d,s,cl,te,cd,sl,ct,cn,rm,lb);
	show_routine(d,s);
end;


create or replace procedure show_routine(d in varchar2,s in number)
as
	crs varchar2(10);
	tch varchar2(10);
	rm varchar2(10);
	lb varchar2(10);
	slt number;
	cursor cmon is select * from routine where cday='Mon';
	cursor ctues is select * from routine where cday='Tues';
	cursor cwed is select * from routine where cday='Wed';
	cursor cthurs is select * from routine where cday='Thurs';
	cursor cfri is select * from routine where cday='Fri';
begin
	dbms_output.put_line('Monday');
	for rec in cmon
	loop
		crs:=rec.course;
		tch:=rec.teacher;
		rm:=rec.room;
		lb:=rec.lab;
		slt:=rec.slot;
		dbms_output.put_line(slt);
		dbms_output.put_line(crs);
		dbms_output.put_line(tch);
		dbms_output.put_line(rm);
		dbms_output.put_line(lb);	
	end loop;
	
	dbms_output.put_line('Tuesday');
	for rec in ctues
	loop
		crs:=rec.course;
		tch:=rec.teacher;
		rm:=rec.room;
		lb:=rec.lab;
		slt:=rec.slot;
		dbms_output.put_line(slt);
		dbms_output.put_line(crs);
		dbms_output.put_line(tch);
		dbms_output.put_line(rm);
		dbms_output.put_line(lb);	
	end loop;
	
	dbms_output.put_line('Wednesday');
	for rec in cwed
	loop
		crs:=rec.course;
		tch:=rec.teacher;
		rm:=rec.room;
		lb:=rec.lab;
		slt:=rec.slot;
		dbms_output.put_line(slt);
		dbms_output.put_line(crs);
		dbms_output.put_line(tch);
		dbms_output.put_line(rm);
		dbms_output.put_line(lb);	
	end loop;
	dbms_output.put_line('Thursday');
	for rec in cthurs
	loop
		crs:=rec.course;
		tch:=rec.teacher;
		rm:=rec.room;
		lb:=rec.lab;
		slt:=rec.slot;
		dbms_output.put_line(slt);
		dbms_output.put_line(crs);
		dbms_output.put_line(tch);
		dbms_output.put_line(rm);
		dbms_output.put_line(lb);	
	end loop;
	dbms_output.put_line('Friday');
	for rec in cfri
	loop
		crs:=rec.course;
		tch:=rec.teacher;
		rm:=rec.room;
		lb:=rec.lab;
		slt:=rec.slot;
		dbms_output.put_line(slt);
		dbms_output.put_line(crs);
		dbms_output.put_line(tch);
		dbms_output.put_line(rm);
		dbms_output.put_line(lb);	
	end loop;
end;
/






	




	





























create or replace procedure class_management_system
as
	n number;
begin
	dbms_output.put_line('Select your choice');
	dbms_output.put_line('1.Manage Info');
	dbms_output.put_line('2.Make Schedule');
	dbms_output.put_line('3.Show Schedule');
	dbms_output.put_line('4.Exit');
	n:=&n;
	IF(n = 1) THEN 
        manage_info();
    ELSIF(n = 2) THEN
        make_schedule();
    ELSIF(n = 3) THEN
        show_schedule();
    ELSIF(n = 4) THEN
        EXIT;
    END IF;
end;
/












--blocks:

begin

class_management_system();

end;
/





