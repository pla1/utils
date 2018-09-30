/*
 PostgreSQL script to create function and trigger for Pleroma email notifications.

 ** This will break your Pleroma instance if you do this wrong. **

 Prerequisites
 1. Mail installed and configured with these 3 commands in these exact locations: /usr/bin/mail, /bin/echo, /usr/bin/xxd
 2. To confirm your configuration you should receive an email from this command - `/bin/echo "68656c6c6f" | /usr/bin/xxd -r -p | /usr/bin/mail -s "test" "You@yourdomain.com"`
 3. Must install this trigger as DB super user (postgres) command: `psql -f /tmp/pleroma_function_email_notifications.sql`

*/

\c pleroma_dev

CREATE OR REPLACE FUNCTION function_notifications_email() RETURNS TRIGGER AS $$

DECLARE
  content text;
  pgm text;
  mentionId text;
  actor text;
  emailAddress text;
  rec record;
  subject text;
  fromName text;
  body text;
  htmlBreak text := '<br>' || E'\n';

BEGIN
FOR rec IN SELECT a.DATA->'object'->>'actor' as actor,
       a.DATA->'object'->>'id' as mentionId,
       b.email as emailAddress,
       a.DATA->'object'->>'content' as content,
       c.name as fromName
FROM activities as a
join users as b
on b.ap_id = any(a.recipients)
join users as c
on a.data->'object'->>'attributedTo' = c.ap_id
WHERE a.id = NEW.activity_id
      and b.local = true
      and b.email is not null
LOOP
subject := 'Pleroma mention from ' || rec.fromName || ' - ' || cast(TimeOfDay() as text) || E'\n' || 'Content-Type: text/html';
body := encode(convert_to('Actor: ' || rec.actor || htmlBreak || ' ID: ' || rec.mentionId || htmlBreak || rec.content,'utf-8'), 'hex');

RAISE LOG 'From: "%" Subject: "%"', rec.fromName, subject;
pgm := format('copy (select 1) to program ''/bin/echo "%s" |  /usr/bin/xxd -r -p | /usr/bin/mail -s "%s" "%s"''', body, subject, rec.emailAddress);

EXECUTE pgm;
END LOOP;

RETURN NULL;

END;

$$ LANGUAGE 'plpgsql' SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_notifications_email ON notifications;

CREATE TRIGGER trigger_notifications_email AFTER
INSERT ON notifications
FOR EACH ROW EXECUTE PROCEDURE function_notifications_email();
