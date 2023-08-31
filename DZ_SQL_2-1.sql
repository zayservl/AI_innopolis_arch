create table students
(
    id serial primary key ,
    name text not null ,
	total_score integer,
	scholarship integer
);

create table activity_scores
(
    student_id integer,
    activity_type text,
	score integer,
	foreign key (student_id) references students(id)
);

create or replace function update_total_score(sid integer) 
returns void as $$
declare
    total integer := 0;
    activity_record record;
begin
    total := 0;

    for activity_record in (select score from activity_scores where student_id = sid) loop
        total := total + activity_record.score;
    end loop;

    update students set total_score = total where id = sid;
    return;
end;
$$ language plpgsql;

create or replace function update_total_score_trigger() 
returns trigger as $$
begin
    
    perform update_total_score(new.student_id);

    return new;
end;
$$ language plpgsql;

-- создаем триггер, который срабатывает после вставки новой записи в activity_scores
create trigger after_activity_scores_insert
after insert on activity_scores
for each row
execute function update_total_score_trigger();

--триггер для обновления стипендий
create or replace function calculate_scholarship()
returns trigger as $$
begin
    if new.total_score >= 90 then
        new.scholarship := 1000;
    elsif new.total_score >= 80 then
        new.scholarship := 500;
    else
        new.scholarship := 0;
    end if;
    return new;
end;
$$ language plpgsql;

create or replace trigger update_scholarship_trigger
before update on students
for each row
execute function calculate_scholarship();

--проверяем
insert into students(id, name, total_score, scholarship) values (1, 'ваня', 0, 0);
insert into students(id, name, total_score, scholarship) values (2, 'ира', 0, 0);

insert into activity_scores(student_id, activity_type, score) values (1, 'математика', 70);
insert into activity_scores(student_id, activity_type, score) values (1, 'физика', 5);
insert into activity_scores(student_id, activity_type, score) values (2, 'физра', 5);
insert into activity_scores(student_id, activity_type, score) values (2, 'математика', 70);

insert into activity_scores(student_id, activity_type, score) values (2, 'физика', 5);
insert into activity_scores(student_id, activity_type, score) values (2, 'литература', 10);
insert into activity_scores(student_id, activity_type, score) values (1, 'физра', 5);
insert into activity_scores(student_id, activity_type, score) values (1, 'литература', 5);

select * from students