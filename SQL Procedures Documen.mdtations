

### **1. `RETRIEVE_OVERDUE_REMINDERS`**

**Description:**
This procedure retrieves overdue reminders for a specific user. It filters reminders that have a reminder time later than the current system time and deletes reminders that have an interval of 0 days.

**Parameters:**
- `r_USER_ID (IN)`: `NUMBER` — The user ID for whom the overdue reminders are to be retrieved.
- `REMINDERS (OUT)`: `SYS_REFCURSOR` — A cursor that will hold the result set of overdue reminders.

**Returned by `SYS_REFCURSOR`:**
- Columns:
  - `REMINDER_ID`: `NUMBER` — The unique identifier for the reminder.
  - `REMINDER_TITLE`: `VARCHAR2(255)` — The title of the reminder.
  - `REMINDER_TIME`: `TIMESTAMP` — The time when the reminder is set.
  - `REMINDER_INTERVAL`: `INTERVAL DAY TO SECOND` — The interval for the reminder.

---

### **2. `RETRIEVE_REMINDERS`**

**Description:**
This procedure retrieves all reminders for a specific user, including reminders with intervals and specific times.

**Parameters:**
- `r_USER_ID (IN)`: `NUMBER` — The user ID for whom the reminders are to be retrieved.
- `REMINDERS (OUT)`: `SYS_REFCURSOR` — A cursor that will hold the result set of all reminders for the user.

**Returned by `SYS_REFCURSOR`:**
- Columns:
  - `REMINDER_ID`: `NUMBER` — The unique identifier for the reminder.
  - `REMINDER_TITLE`: `VARCHAR2(255)` — The title of the reminder.
  - `REMINDER_TIME`: `TIMESTAMP` — The time when the reminder is set.
  - `REMINDER_INTERVAL`: `INTERVAL DAY TO SECOND` — The interval for the reminder.

---

### **3. `DELETE_REMINDERS`**

**Description:**
This procedure deletes a specific reminder for a user.

**Parameters:**
- `r_USER_ID (IN)`: `NUMBER` — The user ID associated with the reminder.
- `r_REMINDER_ID (IN)`: `NUMBER` — The reminder ID to be deleted.

---

### **4. `UPDATE_OVERDUE_REMINDERS`**

**Description:**
This procedure updates the overdue reminders for a specific user by adding the reminder interval to the reminder time.

**Parameters:**
- `r_USER_ID (IN)`: `NUMBER` — The user ID whose overdue reminders are to be updated.

---

### **5. `INSERT_REMINDER`**

**Description:**
This procedure inserts a new reminder for a user.

**Parameters:**
- `r_USER_ID (IN)`: `NUMBER` — The user ID to associate with the reminder.
- `r_REMINDER_TITLE (IN)`: `VARCHAR2(255)` — The title of the reminder.
- `r_REMINDER_TIME (IN)`: `TIMESTAMP` — The time when the reminder is set.
- `r_REMINDER_INTERVAL (IN)`: `INTERVAL DAY TO SECOND` — The interval for the reminder.

---

### **6. `CHECK_USERNAME_AND_PASSWORD`**

**Description:**
This procedure checks whether the given username and password exist in the `diary_users` table.

**Parameters:**
- `u_USERNAME (IN)`: `VARCHAR2(255)` — The username to check.
- `u_USER_PASSWORD (IN)`: `VARCHAR2(255)` — The password associated with the username.
- `o_USER_ID (OUT)`: `NUMBER` — The user ID associated with the given username and password (returns -1 if not found).

---

### **7. `CREATE_USER`**

**Description:**
This procedure creates a new user in the `diary_users` table.

**Parameters:**
- `u_USERNAME (IN)`: `VARCHAR2(255)` — The username of the new user.
- `u_USER_PASSWORD (IN)`: `VARCHAR2(255)` — The password for the new user.
- `FLAG (OUT)`: `CHAR(1)` — Output flag indicating whether the username is available ('Y' if successful, 'N' if the username already exists).

---

### **8. `UPDATE_PASSWORD`**

**Description:**
This procedure allows users to update their password.

**Parameters:**
- `u_USER_ID (IN)`: `NUMBER` — The user ID whose password is to be updated.
- `CURRENT_PASSWORD (IN)`: `VARCHAR2(255)` — The current password of the user.
- `NEW_PASSWORD (IN)`: `VARCHAR2(255)` — The new password to set.
- `FLAG (OUT)`: `CHAR(1)` — Output flag indicating whether the password update was successful ('Y' if successful, 'N' if the current password is incorrect).

---

### **9. `Set_Premium`**

**Description:**
This procedure sets a user's status to "premium."

**Parameters:**
- `USER_ID (IN)`: `NUMBER` — The user ID whose status will be updated to premium.

---

### **10. `remove_Premium`**

**Description:**
This procedure removes the "premium" status of a user.

**Parameters:**
- `USER_ID (IN)`: `NUMBER` — The user ID whose premium status will be removed.

---

### **11. `ADD_DIARY`**

**Description:**
This procedure adds a new diary entry for a user.

**Parameters:**
- `d_USER_ID (IN)`: `NUMBER` — The user ID to associate with the new diary entry.
- `DIARY_ID (OUT)`: `NUMBER` — The ID of the newly created diary entry.

---

### **12. `UPDATE_TITLE_AND_TEXT`**

**Description:**
This procedure updates the title and text of an existing diary entry.

**Parameters:**
- `d_DIARY_ID (IN)`: `NUMBER` — The diary ID of the entry to update.
- `TITLE (IN)`: `VARCHAR2(255)` — The new title for the diary.
- `TEXT (IN)`: `VARCHAR2(4000)` — The new cypher text for the diary.

---

### **13. `RETRIEVE_DIARY`**

**Description:**
This procedure retrieves the title and text of a specific diary entry.

**Parameters:**
- `d_DIARY_ID (IN)`: `NUMBER` — The diary ID to retrieve.
- `DIARY (OUT)`: `SYS_REFCURSOR` — A cursor that will hold the result set of the diary's title and text.

**Returned by `SYS_REFCURSOR`:**
- Columns:
  - `DIARY_ID`: `NUMBER` — The ID of the diary entry.
  - `TITLE`: `VARCHAR2(255)` — The title of the diary entry.
  - `TEXT`: `VARCHAR2(4000)` — The text/content of the diary entry.

---

### **14. `retrieve_titles`**

**Description:**
This procedure retrieves all diary titles for a specific user.

**Parameters:**
- `u_USER_ID (IN)`: `NUMBER` — The user ID to retrieve diary titles for.
- `DIARY (OUT)`: `SYS_REFCURSOR` — A cursor that will hold the result set of the user's diary titles.

**Returned by `SYS_REFCURSOR`:**
- Columns:
  - `DIARY_ID`: `NUMBER` — The ID of the diary entry.
  - `TITLE`: `VARCHAR2(255)` — The title of the diary entry.

---

### **15. `RETRIEVE_IMAGE`**

**Description:**
This procedure retrieves the image path and placement in text for a specific diary entry.

**Parameters:**
- `d_DIARY_ID (IN)`: `NUMBER` — The diary ID to retrieve associated images for.
- `IMAGES (OUT)`: `SYS_REFCURSOR` — A cursor that will hold the result set of the image path and placement.

**Returned by `SYS_REFCURSOR`:**
- Columns:
  - `IMAGE_ID`: `NUMBER` — The ID of the image.
  - `PLACE_IN_TEXT`: `VARCHAR2(255)` — The place where the image is located in the text.
  - `IMAGE_PATH`: `VARCHAR2(255)` — The file path of the image.

---

### **16. `DELETE_DIARY`**

**Description:**
This procedure deletes a specific diary entry.

**Parameters:**
- `d_DIARY_ID (IN)`: `NUMBER` — The diary ID of the entry to be deleted.

---

### **17. `DELETE_IMAGE`**

**Description:**
This procedure deletes a specific image associated with a diary entry.

**Parameters:**
- `d_DIARY_ID (IN)`: `NUMBER` — The diary ID associated with the image.
- `i_IMAGE_ID (IN)`: `NUMBER` — The image ID to be deleted.

---

### **18. `INSERT_IMAGE`**

**Description:**
This procedure inserts a new image for a specific diary entry.

**Parameters:**
- `DIARY_ID (IN)`: `NUMBER` — The ID of the diary entry to associate with the image.
- `PLACE_IN_TEXT (IN)`: `VARCHAR2(255)` — The place where the image is located in the text.
- `IMAGE_PATH (IN)`: `VARCHAR2(255)` — The file path of the image to be inserted.
