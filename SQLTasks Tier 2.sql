{\rtf1\ansi\ansicpg1252\deff0\nouicompat{\fonttbl{\f0\fnil\fcharset0 Courier New;}}
{\colortbl ;\red0\green0\blue255;}
{\*\generator Riched20 10.0.19041}\viewkind4\uc1 
\pard\f0\fs22\lang1033 /* Welcome to the SQL mini project. You will carry out this project partly in\par
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.\par
\par
This is Tier 2 of the case study, which means that there'll be less guidance for you about how to setup\par
your local SQLite connection in PART 2 of the case study. This will make the case study more challenging for you: \par
you might need to do some digging, aand revise the Working with Relational Databases in Python chapter in the previous resource.\par
\par
Otherwise, the questions in the case study are exactly the same as with Tier 1. \par
\par
PART 1: PHPMyAdmin\par
You will complete questions 1-9 below in the PHPMyAdmin interface. \par
Log in by pasting the following URL into your browser, and\par
using the following Username and Password:\par
\par
URL: {{\field{\*\fldinst{HYPERLINK https://sql.springboard.com/ }}{\fldrslt{https://sql.springboard.com/\ul0\cf0}}}}\f0\fs22\par
Username: student\par
Password: learn_sql@springboard\par
\par
The data you need is in the "country_club" database. This database\par
contains 3 tables:\par
    i) the "Bookings" table,\par
    ii) the "Facilities" table, and\par
    iii) the "Members" table.\par
\par
In this case study, you'll be asked a series of questions. You can\par
solve them using the platform, but for the final deliverable,\par
paste the code for each solution into this script, and upload it\par
to your GitHub.\par
\par
Before starting with the questions, feel free to take your time,\par
exploring the data, and getting acquainted with the 3 tables. */\par
\par
\par
/* QUESTIONS \par
/* Q1: Some of the facilities charge a fee to members, but some do not.\par
Write a SQL query to produce a list of the names of the facilities that do. */\par
\par
SELECT * \par
FROM `Facilities` \par
WHERE membercost != 0.0;\par
\par
/* Q2: How many facilities do not charge a fee to members? */\par
\par
\b SELECT COUNT(*)\par
FROM Facilities\par
WHERE membercost = 0.0;\par
\b0\par
\par
/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,\par
where the fee is less than 20% of the facility's monthly maintenance cost.\par
Return the facid, facility name, member cost, and monthly maintenance of the\par
facilities in question. */\par
\par
\b SELECT facid, name, membercost, monthlymaintenance\par
FROM Facilities\par
WHERE membercost != 0 AND\par
\tab membercost <= (.2 * monthlymaintenance);\par
\b0\par
/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.\par
Try writing the query without using the OR operator. */\par
\par
\b SELECT facid, name, membercost, guestcost, initialoutlay, monthlymaintenance\par
FROM Facilities\par
WHERE facid IN (1, 5);\par
\b0\par
/* Q5: Produce a list of facilities, with each labelled as\par
'cheap' or 'expensive', depending on if their monthly maintenance cost is\par
more than $100. Return the name and monthly maintenance of the facilities\par
in question. */\par
\par
\b SELECT name, monthlymaintenance, \par
\tab CASE WHEN monthlymaintenance > 100 THEN 'expensive'\par
\tab ELSE 'cheap' END as cost\par
FROM Facilities;\par
\b0\par
/* Q6: You'd like to get the first and last name of the last member(s)\par
who signed up. Try not to use the LIMIT clause for your solution. */\par
\par
\b SELECT m.memid, m.surname, m.firstname, subquery.last_id\par
FROM Members as m,\par
\tab (SELECT memid, MAX(memid) AS last_id \par
     -- Use the highest ID num for last to join\par
     FROM Members) AS subquery\par
WHERE m.memid = subquery.last_id;\par
\b0\par
\par
/* Q7: Produce a list of all members who have used a tennis court.\par
Include in your output the name of the court, and the name of the member\par
formatted as a single column. Ensure no duplicate data, and order by\par
the member name. */\par
\par
\b SELECT DISTINCT concat(firstname,' ',surname) AS fullname\par
FROM Members as m\par
WHERE memid IN\par
\tab (SELECT b.memid\par
\tab FROM Bookings as b\par
\tab WHERE b.facid IN\par
\tab\tab (SELECT f.facid\par
\tab  \tab FROM Facilities as f\par
\tab  \tab WHERE f.name LIKE 'Tennis Court%'))\par
ORDER BY fullname;\par
\b0\par
/* Q8: Produce a list of bookings on the day of 2012-09-14 which\par
will cost the member (or guest) more than $30. Remember that guests have\par
different costs to members (the listed costs are per half-hour 'slot'), and\par
the guest user's ID is always 0. Include in your output the name of the\par
facility, the name of the member formatted as a single column, and the cost..\par
\par
Order by descending cost, and do not use any subqueries. (12 results) */\par
\par
\b SELECT f.name, CONCAT(m.firstname, ' ', m.surname) AS full_name,\par
\tab CASE WHEN b.memid = 0 THEN b.slots * f.guestcost\par
\tab ELSE b.slots * f.membercost END AS Cost\par
FROM Bookings as b\par
\tab LEFT JOIN Facilities as f\par
\tab ON b.facid = f.facid\par
\tab INNER JOIN Members as m\par
\tab on b.memid = m.memid\par
WHERE starttime LIKE '%2012-09-14%'\b0\par
\b\tab AND \par
\tab (b.memid =0 AND f.guestcost * b.slots > 30.0 OR\par
\tab\tab f.membercost * b.slots > 30.0)\par
ORDER BY Cost DESC;\par
\b0\par
/* Q9: This time, produce the same result as in Q8, but using a subquery. (The same 12 records are produced) */\par
\par
\par
\b SELECT CONCAT(m.firstname, ' ', m.surname), sub.Cost, sub.name, sub.starttime\par
FROM\par
(SELECT b.slots, b.bookid, b.memid, f.name,b.starttime,\par
\tab CASE WHEN b.memid = 0 THEN b.slots * f.guestcost\par
\tab ELSE b.slots * f.membercost END AS Cost\par
FROM Bookings AS b\par
LEFT JOIN Facilities as f\par
ON b.facid = f.facid\par
WHERE b.starttime LIKE '%2012-09-14%') AS sub\par
LEFT JOIN Members as m\par
ON m.memid = sub.memid\par
WHERE Cost > 30\par
ORDER BY Cost DESC;\par
\b0               \par
\par
\par
/* PART 2: SQLite\par
\par
Export the country club data from PHPMyAdmin, and connect to a local SQLite instance from Jupyter notebook \par
for the following questions.  \par
\par
QUESTIONS:\par
/* Q10: Produce a list of facilities with a total revenue less than 1000.\par
The output of facility name and total revenue, sorted by revenue. Remember\par
that there's a different cost for guests and members! */\par
\par
\b SELECT sub2.name, sub2.total_rev\par
FROM(\par
    \par
\tab SELECT sub.name, SUM(sub.revPerBooking) as total_rev\par
\tab FROM (\par
\tab\tab SELECT f.name, b.facid,\par
\tab\tab\tab CASE WHEN b.memid = 0 THEN b.slots * f.guestcost\par
\tab\tab\tab ELSE b.slots * f.membercost END AS revPerBooking\par
\tab\tab FROM Bookings as b\par
\tab\tab LEFT JOIN Facilities AS f\par
\tab\tab ON b.facid = f.facid\par
    \tab\tab ) sub\par
\par
GROUP BY sub.name\par
ORDER BY total_rev DESC) sub2\par
WHERE sub2.total_rev < 1000.00;\par
\b0\par
\par
/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */\par
\par
\b SELECT m1.firstname, m1.surname, m2.firstname AS refname1,\par
\tab m2.surname AS refname2\par
FROM Members as m1\par
LEFT JOIN Members as m2 \par
ON m1.recommendedby = m2.memid\par
ORDER BY m1.surname, m1.firstname;\par
\b0\par
\par
/* Q12: Find the facilities with their usage by member, but not guests */\par
\par
\b SELECT f.name, SUM(b.slots) AS Total_Slots\par
FROM Bookings as b\par
LEFT JOIN Facilities AS f\par
ON b.facid = f.facid\par
WHERE b.memid != 0\par
GROUP BY b.facid;\par
\b0\par
/* Q13: Find the facilities usage by month, but not guests */\par
\par
\b SELECT f.name AS Facility_Name, EXTRACT(MONTH FROM b.starttime ) AS Month, SUM(b.slots) as Total_Slots\par
FROM Bookings AS b\par
LEFT JOIN Facilities AS f\par
ON b.facid = f.facid\par
WHERE b.memid != 0\par
GROUP BY b.facid, Month;\b0\par
\par
\par
}
 