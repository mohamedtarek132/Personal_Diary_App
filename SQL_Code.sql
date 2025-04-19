SET SERVEROUTPUT ON;

-------------------------------------------------------------
------------------------ Create Sequences -------------------
-------------------------------------------------------------
drop sequence diary_user_seq;
drop sequence diary_reminder_seq;
drop sequence diary_seq;
drop sequence diary_image_seq;

CREATE SEQUENCE diary_user_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE diary_reminder_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE diary_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE diary_image_seq START WITH 1 INCREMENT BY 1;

-------------------------------------------------------------
------------------------ Create Tables ----------------------
-------------------------------------------------------------

DROP TABLE diary_image CASCADE CONSTRAINTS;
DROP TABLE diary CASCADE CONSTRAINTS;
DROP TABLE diary_reminder CASCADE CONSTRAINTS;
DROP TABLE diary_users CASCADE CONSTRAINTS;


CREATE TABLE diary_users (
  user_id         INT PRIMARY KEY,
  username        VARCHAR2(255) UNIQUE,
  user_password   VARCHAR2(255),
  premium         CHAR(1) CHECK (premium IN ('Y', 'N'))
);

CREATE TABLE diary_reminder (
  reminder_id       INT PRIMARY KEY,
  user_id           INT REFERENCES diary_users(user_id) ON DELETE CASCADE,
  reminder_interval INTERVAL DAY TO SECOND,
  reminder_time     DATE,
  reminder_title    VARCHAR2(255)
);

CREATE TABLE diary (
  diary_id          INT PRIMARY KEY,
  user_id           INT REFERENCES diary_users(user_id) ON DELETE CASCADE,
  cypher_text       CLOB,
  cypher_title      VARCHAR2(255),
  create_time       DATE,
  last_update_time  DATE
);

CREATE TABLE diary_image (
  image_id       INT PRIMARY KEY,
  diary_id       INT REFERENCES diary(diary_id) ON DELETE CASCADE,
  image_path     VARCHAR2(1000),
  insertion_time DATE,
  place_in_text  INT
);



-------------------------------------------------------------
------------------------ REMINDERS --------------------------
-------------------------------------------------------------
create or replace
PROCEDURE RETRIEVE_OVERDUE_REMINDERS(r_USER_ID INTEGER, REMINDERS OUT SYS_REFCURSOR )
AS
BEGIN
  OPEN reminders FOR 
    SELECT P.REMINDER_TITLE, to_char(P.REMINDER_TIME, 'YYYY-MM-DD HH24:MI:SS'), P.REMINDER_ID
    FROM DIARY_REMINDER P
    WHERE P.USER_ID = r_USER_ID AND P.REMINDER_TIME > SYSDATE;
  DELETE FROM DIARY_REMINDER P WHERE P.USER_ID = r_USER_ID AND P.REMINDER_TIME > SYSDATE AND P.REMINDER_INTERVAL = INTERVAL '0' DAY;
END ;
/
CREATE OR REPLACE 
PROCEDURE RETRIEVE_REMINDERS(r_USER_ID INTEGER, REMINDERS OUT SYS_REFCURSOR )
AS
BEGIN
  OPEN reminders FOR 
    SELECT P.REMINDER_TITLE, to_char(P.REMINDER_TIME, 'YYYY-MM-DD HH24:MI:SS'), P.REMINDER_ID, to_char(P.REMINDER_INTERVAL, 'YYYY-MM-DD HH24:MI:SS')
    FROM DIARY_REMINDER P
    WHERE P.USER_ID = r_USER_ID;
END;
/
CREATE OR REPLACE 
PROCEDURE DELETE_REMINDERS(r_USER_ID INTEGER, r_REMINDER_ID INTEGER)
AS
BEGIN
  DELETE FROM DIARY_REMINDER P WHERE P.user_id = r_USER_ID AND r_REMINDER_ID = P.REMINDER_ID;
END;
/
create or replace
PROCEDURE UPDATE_OVERDUE_REMINDERS(r_USER_ID INTEGER)
AS
BEGIN 
  UPDATE DIARY_REMINDER P 
  SET P.REMINDER_TIME = P.REMINDER_TIME + P.REMINDER_INTERVAL * CEIL((SYSDATE - P.REMINDER_TIME)/(
                                                                                                    EXTRACT(DAY FROM P.REMINDER_INTERVAL) +
                                                                                                    EXTRACT(HOUR FROM P.REMINDER_INTERVAL) / 24 +
                                                                                                    EXTRACT(MINUTE FROM P.REMINDER_INTERVAL) / 1440 +
                                                                                                    EXTRACT(SECOND FROM P.REMINDER_INTERVAL) / 86400
                                                                                                  )) 
  WHERE P.USER_ID = r_USER_ID AND P.REMINDER_TIME < SYSDATE;
END;
/
CREATE OR REPLACE 
PROCEDURE INSERT_REMINDER(
  r_USER_ID           INTEGER, 
  r_REMINDER_TITLE    VARCHAR2, 
  r_REMINDER_TIME     date, 
  r_REMINDER_INTERVAL interval day to second
)
AS
BEGIN
  INSERT INTO diary_reminder 
  VALUES (
    DIARY_REMINDER_SEQ.NEXTVAL, 
    r_USER_ID, 
    r_REMINDER_INTERVAL,
    TO_DATE(r_REMINDER_TIME, 'YYYY-MM-DD HH24:MI:SS'),
    r_REMINDER_TITLE 
    );
END;


/




-------------------------------------------------------------
------------------------ Users ------------------------------
-------------------------------------------------------------

CREATE OR REPLACE
PROCEDURE CHECK_USERNAME_AND_PASSWORD(u_USERNAME VARCHAR2, u_USER_PASSWORD VARCHAR2, o_USER_ID OUT INTEGER)
AS
BEGIN
SELECT case when count(*) > 0 then min(u.user_id) else -1 end INTO o_USER_ID
FROM diary_users U
WHERE u_USERNAME = U.USERNAME AND u_USER_PASSWORD = U.USER_PASSWORD;
END;
/
create or replace
PROCEDURE CREATE_USER (u_USERNAME VARCHAR2, u_USER_PASSWORD VARCHAR2, FLAG OUT CHAR)
AS
counter Integer;
BEGIN
  SELECT count(*) INTO counter
  FROM diary_users U
  WHERE U.username = u_USERNAME;  
  IF counter = 0 THEN
    FLAG := 'Y';
    INSERT INTO diary_users VALUES (DIARY_USER_SEQ.NEXTVAL, u_USERNAME, u_USER_PASSWORD, 'N');
  ELSE
    Flag:='N';
  END IF;
END;
/
CREATE OR REPLACE
PROCEDURE UPDATE_PASSWORD (u_USER_ID INTEGER, CURRENT_PASSWORD varchar2, NEW_PASSWORD varchar2, FLAG OUT CHAR)
AS
counter Integer;
BEGIN
  SELECT count(*) INTO counter
  FROM DIARY_USERS U
  WHERE U.USER_ID = u_USER_ID AND U.user_password = current_password;
  
  IF counter = 0 THEN
    FLAG := 'N';
  ELSE
    Flag := 'Y';
    UPDATE DIARY_USERS U SET U.user_password = new_password WHERE U.user_id = u_USER_ID;
  END IF;
END;
/
CREATE OR REPLACE
PROCEDURE Set_Premium (USER_ID INTEGER)
AS
BEGIN
  UPDATE DIARY_USERS U SET U.PREMIUM = 'Y' WHERE U.user_id = user_id;
END;
/
CREATE OR REPLACE
PROCEDURE remove_Premium (USER_ID INTEGER)
AS
BEGIN
  UPDATE DIARY_USERS U SET U.PREMIUM = 'N' WHERE U.user_id = user_id;
END;
/


-------------------------------------------------------------
------------------------ Diary ------------------------------
-------------------------------------------------------------

CREATE OR REPLACE 
PROCEDURE ADD_DIARY (d_USER_ID INTEGER, DIARY_ID OUT INTEGER)
AS
BEGIN
  INSERT INTO DIARY VALUES(DIARY_SEQ.NEXTVAL, d_USER_ID, '', 'NEW DIARY', SYSDATE, SYSDATE);
  DIARY_ID := DIARY_SEQ.CURRVAL;
END;
/
CREATE OR REPLACE
PROCEDURE UPDATE_TITLE_AND_TEXT(d_DIARY_ID INTEGER, TITLE VARCHAR, TEXT CLOB)
AS
BEGIN
  UPDATE DIARY D 
  SET D.CYPHER_TITLE = TITLE, D.cypher_text = TEXT, D.LAST_UPDATE_TIME = sysdate
  WHERE d_DIARY_ID = D.diary_id;
END;
/
CREATE OR REPLACE 
PROCEDURE RETRIEVE_DIARY (d_DIARY_ID INTEGER, DIARY OUT SYS_REFCURSOR)
AS
BEGIN
  OPEN DIARY FOR
    SELECT D.CYPHER_TEXT, D.CYPHER_TITLE, to_char(D.CREATE_TIME, 'YYYY-MM-DD HH24:MI:SS'), to_char(D.LAST_UPDATE_TIME, 'YYYY-MM-DD HH24:MI:SS')
    FROM DIARY D
    WHERE d_DIARY_ID = D.DIARY_ID;
END;
/
CREATE OR REPLACE 
PROCEDURE retrieve_titles (u_USER_ID INTEGER, DIARY OUT SYS_REFCURSOR)
AS
BEGIN
  OPEN DIARY FOR
    SELECT D.DIARY_ID, D.CYPHER_TITLE, to_char(D.CREATE_TIME, 'YYYY-MM-DD HH24:MI:SS'), to_char(D.LAST_UPDATE_TIME, 'YYYY-MM-DD HH24:MI:SS')
    FROM DIARY D
    WHERE u_USER_ID = D.USER_ID;
END;
/




-------------------------------------------------------------
------------------------ Image ------------------------------
-------------------------------------------------------------
CREATE OR REPLACE
PROCEDURE RETRIEVE_IMAGE (d_DIARY_ID INTEGER, IMAGES OUT SYS_REFCURSOR)
AS
BEGIN
  OPEN IMAGES FOR
    SELECT IMAGE_PATH, PLACE_IN_TEXT
    FROM DIARY_IMAGE I
    WHERE d_DIARY_ID = I.DIARY_ID;
END;
/
CREATE OR REPLACE
PROCEDURE DELETE_DIARY (d_DIARY_ID INTEGER)
AS
BEGIN
  DELETE FROM DIARY I WHERE I.diary_id = d_DIARY_ID;
END;
/
create or replace
PROCEDURE DELETE_IMAGE (d_DIARY_ID INTEGER, i_IMAGE_ID INTEGER)
AS
BEGIN
  DELETE FROM DIARY_IMAGE I WHERE I.diary_id = d_DIARY_ID AND I.image_id = i_IMAGE_ID;
END;
/
create or replace
PROCEDURE INSERT_IMAGE (DIARY_ID INTEGER, PLACE_IN_TEXT INTEGER, IMAGE_PATH VARCHAR2)
AS
BEGIN
  INSERT INTO DIARY_IMAGE I VALUES (diary_image_seq.NEXTVAL, diary_id, image_path, SYSDATE, place_in_text);
END;
/


-------------------------------------------------------------
------------------------ Insertion --------------------------
-------------------------------------------------------------
INSERT INTO diary_users (user_id, username, user_password, premium) 
VALUES (diary_user_seq.NEXTVAL, 'johndoe', 'password123', 'Y');

-- Uncomment and use the following lines as needed
 INSERT INTO diary_users (user_id, username, user_password, premium) 
 VALUES (diary_user_seq.NEXTVAL, 'janedoe', 'mypassword', 'N');

 INSERT INTO diary_users (user_id, username, user_password, premium) 
 VALUES (diary_user_seq.NEXTVAL, 'susan89', 'secretpassword', 'Y');

 INSERT INTO diary_users (user_id, username, user_password, premium) 
 VALUES (diary_user_seq.NEXTVAL, 'david_miller', 'david1234', 'N');

 INSERT INTO diary_users (user_id, username, user_password, premium) 
 VALUES (diary_user_seq.NEXTVAL, 'lucas_smith', 'lucas2021', 'Y');

 INSERT INTO diary_users (user_id, username, user_password, premium) 
 VALUES (diary_user_seq.NEXTVAL, 'emily_williams', 'emily987', 'N');

 INSERT INTO diary_users (user_id, username, user_password, premium) 
 VALUES (diary_user_seq.NEXTVAL, 'michael_jones', 'mjones2022', 'Y');

 INSERT INTO diary_users (user_id, username, user_password, premium) 
 VALUES (diary_user_seq.NEXTVAL, 'sara_lee', 'sara_1234', 'N');

 INSERT INTO diary_users (user_id, username, user_password, premium) 
 VALUES (diary_user_seq.NEXTVAL, 'william_brown', 'will123', 'Y');

 INSERT INTO diary_users (user_id, username, user_password, premium) 
 VALUES (diary_user_seq.NEXTVAL, 'chloe_davis', 'chloe$123', 'N');

 INSERT INTO diary_users (user_id, username, user_password, premium) 
 VALUES (diary_user_seq.NEXTVAL, 'jackson_clark', 'jacksonpass', 'Y');

 INSERT INTO diary_users (user_id, username, user_password, premium) 
 VALUES (diary_user_seq.NEXTVAL, 'olivia_martin', 'olivia2020', 'N');

 INSERT INTO diary_users (user_id, username, user_password, premium) 
 VALUES (diary_user_seq.NEXTVAL, 'brian_rodgers', 'brian9876', 'Y');

 INSERT INTO diary_users (user_id, username, user_password, premium) 
 VALUES (diary_user_seq.NEXTVAL, 'emma_hall', 'emma@2021', 'N');

 INSERT INTO diary_users (user_id, username, user_password, premium) 
 VALUES (diary_user_seq.NEXTVAL, 'james_taylor', 'jamest@123', 'Y');

 INSERT INTO diary_users (user_id, username, user_password, premium) 
 VALUES (diary_user_seq.NEXTVAL, 'natalie_king', 'natking123', 'N');

 INSERT INTO diary_users (user_id, username, user_password, premium) 
 VALUES (diary_user_seq.NEXTVAL, 'daniel_thompson', 'daniel@22', 'Y');

 INSERT INTO diary_users (user_id, username, user_password, premium) 
 VALUES (diary_user_seq.NEXTVAL, 'mia_white', 'mia12345', 'N');

 INSERT INTO diary_users (user_id, username, user_password, premium) 
 VALUES (diary_user_seq.NEXTVAL, 'henry_moore', 'henry!2022', 'Y');

 INSERT INTO diary_users (user_id, username, user_password, premium) 
 VALUES (diary_user_seq.NEXTVAL, 'sophia_james', 'sophia_j@2021', 'N');

 INSERT INTO diary_reminder (reminder_id, user_id, reminder_interval, reminder_time, reminder_title) 
 VALUES (diary_reminder_seq.NEXTVAL, 2, INTERVAL '1' DAY, TO_DATE('2025-05-10 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Doctor Appointment');

 INSERT INTO diary_reminder (reminder_id, user_id, reminder_interval, reminder_time, reminder_title) 
 VALUES (diary_reminder_seq.NEXTVAL, 2, INTERVAL '2' DAY, TO_DATE('2025-04-12 15:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Lunch with Friends');

 INSERT INTO diary_reminder (reminder_id, user_id, reminder_interval, reminder_time, reminder_title) 
 VALUES (diary_reminder_seq.NEXTVAL, 3, INTERVAL '3' DAY, TO_DATE('2025-03-25 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Meeting with Client');

 INSERT INTO diary_reminder (reminder_id, user_id, reminder_interval, reminder_time, reminder_title) 
 VALUES (diary_reminder_seq.NEXTVAL, 4, INTERVAL '4' DAY, TO_DATE('2025-05-05 09:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Conference Call');

 INSERT INTO diary_reminder (reminder_id, user_id, reminder_interval, reminder_time, reminder_title) 
 VALUES (diary_reminder_seq.NEXTVAL, 5, INTERVAL '5' DAY, TO_DATE('2025-06-10 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Project Deadline');

 INSERT INTO diary_reminder (reminder_id, user_id, reminder_interval, reminder_time, reminder_title) 
 VALUES (diary_reminder_seq.NEXTVAL, 6, INTERVAL '1' HOUR, TO_DATE('2025-05-18 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Flight Departure');

 INSERT INTO diary_reminder (reminder_id, user_id, reminder_interval, reminder_time, reminder_title) 
 VALUES (diary_reminder_seq.NEXTVAL, 7, INTERVAL '10' MINUTE, TO_DATE('2025-04-20 20:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Dinner Reservation');

 INSERT INTO diary_reminder (reminder_id, user_id, reminder_interval, reminder_time, reminder_title) 
 VALUES (diary_reminder_seq.NEXTVAL, 8, INTERVAL '2' DAY, TO_DATE('2025-07-12 11:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Anniversary Reminder');

 INSERT INTO diary_reminder (reminder_id, user_id, reminder_interval, reminder_time, reminder_title) 
 VALUES (diary_reminder_seq.NEXTVAL, 9, INTERVAL '15' MINUTE, TO_DATE('2025-04-28 08:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'Morning Workout');

 INSERT INTO diary_reminder (reminder_id, user_id, reminder_interval, reminder_time, reminder_title) 
 VALUES (diary_reminder_seq.NEXTVAL, 10, INTERVAL '1' DAY, TO_DATE('2025-06-02 07:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Yoga Session');

 INSERT INTO diary_reminder (reminder_id, user_id, reminder_interval, reminder_time, reminder_title) 
 VALUES (diary_reminder_seq.NEXTVAL, 11, INTERVAL '3' DAY, TO_DATE('2025-08-15 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Team Meeting');

 INSERT INTO diary_reminder (reminder_id, user_id, reminder_interval, reminder_time, reminder_title) 
 VALUES (diary_reminder_seq.NEXTVAL, 12, INTERVAL '7' DAY, TO_DATE('2025-09-22 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Dentist Appointment');

 INSERT INTO diary_reminder (reminder_id, user_id, reminder_interval, reminder_time, reminder_title) 
 VALUES (diary_reminder_seq.NEXTVAL, 13, INTERVAL '30' MINUTE, TO_DATE('2025-05-01 14:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Coffee Break');

 INSERT INTO diary_reminder (reminder_id, user_id, reminder_interval, reminder_time, reminder_title) 
 VALUES (diary_reminder_seq.NEXTVAL, 14, INTERVAL '3' HOUR, TO_DATE('2025-06-28 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Evening Run');

 INSERT INTO diary_reminder (reminder_id, user_id, reminder_interval, reminder_time, reminder_title) 
 VALUES (diary_reminder_seq.NEXTVAL, 15, INTERVAL '5' DAY, TO_DATE('2025-10-30 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Birthday Party');

 INSERT INTO diary_reminder (reminder_id, user_id, reminder_interval, reminder_time, reminder_title) 
 VALUES (diary_reminder_seq.NEXTVAL, 16, INTERVAL '2' HOUR, TO_DATE('2025-04-15 10:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'Product Launch');

 INSERT INTO diary_reminder (reminder_id, user_id, reminder_interval, reminder_time, reminder_title) 
 VALUES (diary_reminder_seq.NEXTVAL, 2, INTERVAL '1' day, TO_DATE('2025-07-25 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'Weekly Review');


INSERT INTO diary (diary_id, user_id, cypher_text, cypher_title, create_time, last_update_time)
VALUES (diary_seq.NEXTVAL, 2, 'Today I had a calm and peaceful day, focusing on work and some light reading. The weather was perfect for a walk in the park.', 'A Peaceful Day', TO_DATE('2025-03-01 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-03-01 08:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO diary (diary_id, user_id, cypher_text, cypher_title, create_time, last_update_time)
VALUES (diary_seq.NEXTVAL, 2, 'A busy day at work, but I managed to squeeze in some time for a coffee break with a good friend. We talked about our upcoming plans for the weekend.', 'Work and Catching Up', TO_DATE('2025-04-05 09:30:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-04-05 09:50:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO diary (diary_id, user_id, cypher_text, cypher_title, create_time, last_update_time)
VALUES (diary_seq.NEXTVAL, 3, 'A stressful but rewarding day. Managed to complete a project I had been working on for weeks, but now I feel exhausted. Time for a well-deserved break!', 'Project Completion', TO_DATE('2025-02-18 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-02-18 18:15:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO diary (diary_id, user_id, cypher_text, cypher_title, create_time, last_update_time)
VALUES (diary_seq.NEXTVAL, 4, 'Went for a long walk this morning and found myself thinking about life and future goals. Feeling inspired to work harder and stay focused.', 'Morning Reflection', TO_DATE('2025-05-12 07:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-05-12 07:10:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO diary (diary_id, user_id, cypher_text, cypher_title, create_time, last_update_time)
VALUES (diary_seq.NEXTVAL, 5, 'Had a wonderful lunch with family today. We discussed everything from old memories to future plans. It was great to reconnect with everyone.', 'Family Gathering', TO_DATE('2025-01-19 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-01-19 13:45:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO diary (diary_id, user_id, cypher_text, cypher_title, create_time, last_update_time)
VALUES (diary_seq.NEXTVAL, 6, 'Spent the day working on personal projects. The progress was steady, but there’s still a lot to do. Looking forward to a relaxing weekend!', 'Personal Projects', TO_DATE('2025-02-22 16:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-02-22 16:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO diary (diary_id, user_id, cypher_text, cypher_title, create_time, last_update_time)
VALUES (diary_seq.NEXTVAL, 7, 'I had an amazing dinner with friends tonight. We shared lots of laughs and good food. It’s always great to catch up with close friends.', 'Dinner with Friends', TO_DATE('2025-03-10 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-03-10 21:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO diary (diary_id, user_id, cypher_text, cypher_title, create_time, last_update_time)
VALUES (diary_seq.NEXTVAL, 8, 'Had a productive meeting with the team today. We laid out the roadmap for the next quarter and discussed key priorities. Feeling optimistic about the direction we’re headed in.', 'Team Meeting', TO_DATE('2025-03-15 10:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-03-15 10:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO diary (diary_id, user_id, cypher_text, cypher_title, create_time, last_update_time)
VALUES (diary_seq.NEXTVAL, 9, 'Today was a mix of ups and downs. I faced some challenges at work, but I also learned a lot. Trying to stay positive and keep pushing forward.', 'Work Challenges', TO_DATE('2025-04-01 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-04-01 14:30:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO diary (diary_id, user_id, cypher_text, cypher_title, create_time, last_update_time)
VALUES (diary_seq.NEXTVAL, 10, 'A quiet day at home, spent most of it catching up on reading and doing some much-needed housework. It’s nice to have a low-key day every once in a while.', 'Quiet Day', TO_DATE('2025-02-10 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2025-02-10 12:30:00', 'YYYY-MM-DD HH24:MI:SS'));
