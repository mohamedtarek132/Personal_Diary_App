SET SERVEROUTPUT ON;

DECLARE
  v_user_id INTEGER;
  v_flag CHAR;
  v_diary_id INTEGER;
  v_cursor SYS_REFCURSOR;

  -- Variables for REMINDER cursor
  v_title VARCHAR2(255);
  v_time_str VARCHAR2(50);
  v_reminder_id NUMBER;
  v_interval_str VARCHAR2(50);

  -- Variables for DIARY cursor
  v_dtitle VARCHAR2(255);
  v_dtext CLOB;
  v_ctime VARCHAR2(50);
  v_lutime VARCHAR2(50);

  -- Variables for TITLES cursor
  v_tid NUMBER;
  v_ttitle VARCHAR2(255);

  -- Variables for IMAGE cursor
  v_image_id NUMBER;
  v_size NUMBER;
  v_path VARCHAR2(255);
BEGIN
  -- CREATE_USER
  CREATE_USER('test_user', 'test_pass', v_flag);
  DBMS_OUTPUT.PUT_LINE('Create User Flag: ' || v_flag);

  -- CHECK_USERNAME_AND_PASSWORD
  CHECK_USERNAME_AND_PASSWORD('test_user', 'test_pass', v_user_id);
  DBMS_OUTPUT.PUT_LINE('User ID: ' || v_user_id);

  -- UPDATE_PASSWORD
  UPDATE_PASSWORD(v_user_id, 'test_pass', 'new_pass', v_flag);
  DBMS_OUTPUT.PUT_LINE('Update Password Flag: ' || v_flag);

  -- Set and remove Premium
  Set_Premium(v_user_id);
  remove_Premium(v_user_id);

  -- INSERT_REMINDER
  INSERT_REMINDER(v_user_id, 'Test Reminder', SYSDATE + 1, INTERVAL '1' DAY);

  -- RETRIEVE_REMINDERS
  RETRIEVE_REMINDERS(v_user_id, v_cursor);
  LOOP
    FETCH v_cursor INTO v_title, v_time_str, v_reminder_id, v_interval_str;
    EXIT WHEN v_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Reminder: ' || v_title || ' | ' || v_time_str || ' | ID: ' || v_reminder_id || ' | Interval: ' || v_interval_str);
  END LOOP;
  CLOSE v_cursor;

  -- RETRIEVE_OVERDUE_REMINDERS
  RETRIEVE_OVERDUE_REMINDERS(v_user_id, v_cursor);
  LOOP
    FETCH v_cursor INTO v_title, v_time_str, v_reminder_id;
    EXIT WHEN v_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Overdue: ' || v_title || ' | ' || v_time_str || ' | ID: ' || v_reminder_id || ' | Interval: ' || v_interval_str);
  END LOOP;
  CLOSE v_cursor;

  -- UPDATE_OVERDUE_REMINDERS
  UPDATE_OVERDUE_REMINDERS(v_user_id);

  -- DELETE_REMINDERS (example ID = 1)
  DELETE_REMINDERS(v_user_id, 1);

  -- ADD_DIARY
  ADD_DIARY(v_user_id, v_diary_id);
  DBMS_OUTPUT.PUT_LINE('New Diary ID: ' || v_diary_id);

  -- UPDATE_TITLE_AND_TEXT
  UPDATE_TITLE_AND_TEXT(v_diary_id, 'My Title', 'This is the diary text.');

  -- RETRIEVE_DIARY
  RETRIEVE_DIARY(v_diary_id, v_cursor);
  LOOP
    FETCH v_cursor INTO v_dtitle, v_dtext, v_ctime, v_lutime;
    EXIT WHEN v_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Diary Title: ' || v_dtitle);
    DBMS_OUTPUT.PUT_LINE('Text: ' || v_dtext);
    DBMS_OUTPUT.PUT_LINE('Created: ' || v_ctime || ' | Updated: ' || v_lutime);
  END LOOP;
  CLOSE v_cursor;

  -- retrieve_titles
  retrieve_titles(v_user_id, v_cursor);
  LOOP
    FETCH v_cursor INTO v_tid, v_ttitle, v_ctime, v_lutime;
    EXIT WHEN v_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Diary ID: ' || v_tid || ' | Title: ' || v_ttitle);
  END LOOP;
  CLOSE v_cursor;

  -- INSERT_IMAGE
  INSERT_IMAGE(v_diary_id, 5, 'path/to/image.jpg');

  -- RETRIEVE_IMAGE
  RETRIEVE_IMAGE(v_diary_id, v_cursor);
  LOOP
    FETCH v_cursor INTO  v_path, v_image_id;
    EXIT WHEN v_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Image ID: ' || v_image_id  || ' | Path: ' || v_path);
  END LOOP;
  CLOSE v_cursor;

  -- DELETE_IMAGE (example ID = 1)
  DELETE_IMAGE(v_diary_id, 1);

  -- DELETE_DIARY
  DELETE_DIARY(v_diary_id);
END;
/
