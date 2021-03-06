import praw
import datetime
import sys
import time
import os

def generateStuff(comment, author):
  comment_file.write(comment.author.name)
  comment_file.write("\n")
  for reply in comment.replies:
    if reply.author is not None:
      reply_file.write("%s,%s" %(author, reply.author.name))
      reply_file.write("\n")
      generateStuff(reply, reply.author.name)

DATE_FORMAT = "%Y%m%d"
ARCHIVE_DIR = "archive"
user_agent = "OkCupid Crush 1.0"

r = praw.Reddit(user_agent = user_agent)

subreddit = r.get_subreddit("OkCupid")

if len(sys.argv) < 3:
  dirs = os.listdir( ARCHIVE_DIR )
  sorted(dirs)
  start_date = datetime.datetime.strptime(dirs[-1].split('_')[1][:-4], DATE_FORMAT).date() + datetime.timedelta(days=1)
  end_date = datetime.date.fromordinal(datetime.date.today().toordinal()-1)
  print("Processing from %s to %s" % (start_date.strftime(DATE_FORMAT), end_date.strftime(DATE_FORMAT)))
else:
  start_date = datetime.datetime.strptime(sys.argv[1], DATE_FORMAT).date()
  end_date = datetime.datetime.strptime(sys.argv[2], DATE_FORMAT).date()

curr_date = end_date
comment_file = open("%s/Comment_%s.txt" % (ARCHIVE_DIR, curr_date.strftime(DATE_FORMAT)), 'w')
reply_file = open("%s/Reply_%s.txt" % (ARCHIVE_DIR, curr_date.strftime(DATE_FORMAT)), 'w')

for submission in subreddit.get_new(limit = 1000):

  #Convert the submissiont in epoch to a string date and then into a date object, we only want day level granularity
  sub_date = datetime.datetime.strptime(time.strftime(DATE_FORMAT, time.localtime(submission.created)), DATE_FORMAT).date()

  #If we are looking at data before the start date, we are done and can exit
  if start_date > sub_date:
    print("Submission too old exiting: %s" % sub_date.strftime(DATE_FORMAT))
    comment_file.close()
    reply_file.close()
    sys.exit()

  #If we are looking at data after the end date, we need to go back further
  if sub_date > end_date:
    continue

  #If we are looking at a new date, create a new file
  if sub_date != curr_date:
    curr_date = sub_date
    comment_file.close()
    reply_file.close()
    comment_file = open("%s/Comment_%s.txt" % (ARCHIVE_DIR, curr_date.strftime(DATE_FORMAT)), 'w')
    reply_file = open("%s/Reply_%s.txt" % (ARCHIVE_DIR, curr_date.strftime(DATE_FORMAT)), 'w')

  try:
    print "Processing thread %s on %s" %(submission.title,sub_date.strftime(DATE_FORMAT))
  except UnicodeEncodeError:
    print("UnicodeEncodeError")

  submission.replace_more_comments(limit=None, threshold=0)
  for comment in submission.comments:
    if comment.author is not None:
      generateStuff(comment, comment.author.name)


